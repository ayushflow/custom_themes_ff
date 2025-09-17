# Font Files Directory

This directory contains font files that are served dynamically by the API endpoint `/api/fonts/:fontFamily/:fontWeight`.

## Dynamic Font Serving

The API now supports **any font family and weight combination**! Simply add font files to this directory following the naming convention:

**Format**: `{FontFamily}-{FontWeight}.ttf`

### Examples:
- `Inter-Regular.ttf`
- `Inter-Medium.ttf`
- `Inter-SemiBold.ttf`
- `Inter-Bold.ttf`
- `Roboto-Regular.ttf`
- `Roboto-Bold.ttf`
- `OpenSans-Medium.ttf`
- `OpenSans-SemiBold.ttf`

## Currently Available Fonts

### Inter Font Family
- `Inter-Regular.ttf` - Regular weight (400)
- `Inter-Medium.ttf` - Medium weight (500)  
- `Inter-SemiBold.ttf` - Semi Bold weight (600)
- `Inter-Bold.ttf` - Bold weight (700)

## Font Loading Priority

The system follows this priority order:

1. **Cache** - Check if font is already loaded in memory
2. **Assets** - Check Flutter app's `assets/fonts/` directory
3. **API** - Download from this backend endpoint
4. **Google Fonts** - Fallback to Google Fonts service

## How to Add New Font Files

1. Download font files from [Google Fonts](https://fonts.google.com/) or other sources
2. Place the `.ttf` files in this directory with the naming convention: `{FontFamily}-{FontWeight}.ttf`
3. Restart the backend server
4. The API will automatically serve these font files when requested

### Naming Rules:
- Use hyphens (`-`) to separate font family and weight
- Font family names should be one word (e.g., "OpenSans" not "Open-Sans")
- Font weights should be in proper case (e.g., "Semi Bold" → "SemiBold")

## API Endpoints

### Serve Font File
```
GET /api/fonts/{fontFamily}/{fontWeight}
```

**Examples:**
```
GET /api/fonts/Inter/Regular
GET /api/fonts/Inter/Medium
GET /api/fonts/Inter/Semi%20Bold
GET /api/fonts/Inter/Bold
GET /api/fonts/Roboto/Bold
GET /api/fonts/OpenSans/Medium
```

### List Available Fonts
```
GET /api/fonts
```

Returns a JSON response with all available font files and their parsed family/weight information.

## Error Handling

If a requested font file doesn't exist, the API will:
1. Return a 404 status code
2. List all available fonts in the response
3. Suggest the expected file format
4. Log the request for debugging

## Caching

Font files are cached by the browser for 1 year (`Cache-Control: public, max-age=31536000`) to improve performance.

## Testing Fonts

You can test the font serving by:
1. Visiting `http://localhost:3000/api/fonts` to see all available fonts
2. Using the font in your themes by specifying the font family in the theme's typography configuration
3. Checking the browser's Network tab to see font requests and responses
