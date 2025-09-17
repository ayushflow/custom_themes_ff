#!/bin/bash

# Script to pull code from FlutterFlow and then clean up font overrides
# This script exports the latest code from FlutterFlow and removes problematic font overrides

echo "🚀 Starting FlutterFlow code pull and font override cleanup..."
echo ""

# Step 1: Export code from FlutterFlow
echo "📥 Exporting code from FlutterFlow..."
echo "Project: dynamic-theme-8ihfh8"
echo ""

flutterflow export-code \
  --project dynamic-theme-8ihfh8 \
  --endpoint https://api-enterprise-india.flutterflow.io/v2 \
  --project-environment Production \
  --include-assets \
  --token 47e537f4-2d1d-47e0-ae04-10437ece149c \
  --no-parent-folder

# Check if the export was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ FlutterFlow code export completed successfully!"
    echo ""
    
    # Step 2: Run the font overrides replacement script
    echo "🔧 Running font overrides cleanup script..."
    echo ""
    
    # Make sure the script is executable
    chmod +x replace_font_overrides.sh
    
    # Execute the font overrides script
    ./replace_font_overrides.sh
    
    echo ""
    echo "🎉 FlutterFlow code pull and font override cleanup completed!"
    echo ""
    echo "Next steps:"
    echo "  • Review the changes made by the font override script"
    echo "  • Test your app to ensure everything works correctly"
    echo "  • Commit your changes to version control"
    
else
    echo ""
    echo "❌ FlutterFlow code export failed!"
    echo "Please check your connection and credentials, then try again."
    exit 1
fi
