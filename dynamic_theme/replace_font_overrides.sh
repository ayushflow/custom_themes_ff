#!/bin/bash

# Script to replace fontFamily: 'Inter_24' and letterSpacing: 0.0 overrides 
# within .override() methods in *_widget.dart files
# This prevents the custom typography system from being overridden.

echo "🔍 Searching for fontFamily: 'Inter_24' and letterSpacing: 0.0 overrides in *_widget.dart files..."

# Find all *_widget.dart files in the lib directory
dart_files=$(find lib -name "*_widget.dart" -type f)

if [ -z "$dart_files" ]; then
    echo "❌ No *_widget.dart files found in lib directory"
    exit 1
fi

echo "📁 Found $(echo "$dart_files" | wc -l) *_widget.dart files to process"

# Counter for modified files
modified_count=0
total_replacements=0

# Process each file
while IFS= read -r file; do
    echo "🔧 Processing: $file"
    
    # Check if file contains any of the target overrides within .override() methods
    has_font_family=$(grep -A 20 -B 5 "\.override(" "$file" | grep -c "fontFamily: 'Inter_24'" || true)
    has_letter_spacing=$(grep -A 20 -B 5 "\.override(" "$file" | grep -c "letterSpacing: 0\.0" || true)
    
    if [ "$has_font_family" -gt 0 ] || [ "$has_letter_spacing" -gt 0 ]; then
        # Count total occurrences before replacement
        font_family_count=$(grep -c "fontFamily: 'Inter_24'" "$file" || true)
        letter_spacing_count=$(grep -c "letterSpacing: 0\.0" "$file" || true)
        total_before=$((font_family_count + letter_spacing_count))
        
        # Create a backup
        cp "$file" "$file.backup"
        
        # Use awk to process the file and remove lines within .override() methods
        awk '
        BEGIN { in_override = 0; brace_count = 0 }
        /\.override\(/ { 
            in_override = 1
            brace_count = 0
            print $0
            next
        }
        in_override {
            # Count braces to track when we exit the override method
            for (i = 1; i <= length($0); i++) {
                char = substr($0, i, 1)
                if (char == "{") brace_count++
                if (char == "}") brace_count--
            }
            
            # Skip lines that match our target patterns
            if ($0 ~ /fontFamily: '\''Inter_24'\'',/ || $0 ~ /letterSpacing: 0\.0,/) {
                next
            }
            
            # If we hit a closing brace and brace_count is 0, we are exiting the override
            if (brace_count <= 0 && $0 ~ /}/) {
                in_override = 0
            }
        }
        { print $0 }
        ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
        
        # Count occurrences after replacement
        font_family_after=$(grep -c "fontFamily: 'Inter_24'" "$file" || true)
        letter_spacing_after=$(grep -c "letterSpacing: 0\.0" "$file" || true)
        total_after=$((font_family_after + letter_spacing_after))
        actual_removed=$((total_before - total_after))
        
        if [ "$actual_removed" -gt 0 ]; then
            echo "  ✅ Removed $actual_removed override(s) from .override() methods"
            ((modified_count++))
            ((total_replacements += actual_removed))
            # Remove backup since replacement was successful
            rm "$file.backup"
        else
            echo "  ❌ Failed to remove overrides from .override() methods"
            # Restore from backup
            mv "$file.backup" "$file"
        fi
    else
        echo "  ➖ No target overrides found in .override() methods"
    fi
done <<< "$dart_files"

echo ""
echo "=================================================="
echo "REPLACEMENT SUMMARY"
echo "=================================================="
echo "Files processed: $(echo "$dart_files" | wc -l)"
echo "Files modified: $modified_count"
echo "Total replacements: $total_replacements"
echo ""
echo "🎉 Script completed successfully!"

# Optional: Show which files were modified
if [ "$modified_count" -gt 0 ]; then
    echo ""
    echo "Modified files:"
    while IFS= read -r file; do
        # Check if file still has any of our target patterns
        if ! grep -q "fontFamily: 'Inter_24'" "$file" 2>/dev/null && ! grep -q "letterSpacing: 0\.0" "$file" 2>/dev/null; then
            echo "  📝 $file"
        fi
    done <<< "$dart_files"
fi