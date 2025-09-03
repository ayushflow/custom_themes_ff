const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS for all origins
app.use(cors());
app.use(express.json());

// Logging middleware
app.use((req, res, next) => {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] ${req.method} ${req.path} - IP: ${req.ip || 'unknown'}`);
    next();
});

// Sample theme data
const sampleThemes = [
    {
        id: 'ocean-breeze',
        name: 'Ocean Breeze',
        description: 'Cool ocean-inspired colors with blues and teals',
        colors: {
            primary: '#1E88E5',
            secondary: '#00ACC1',
            tertiary: '#26A69A',
            primaryBackground: '#F0F8FF',
            secondaryBackground: '#FFFFFF',
            primaryText: '#1A1A1A',
            secondaryText: '#666666',
            alternate: '#E3F2FD',
            accent1: '#331E88E5',
            accent2: '#3300ACC1',
            accent3: '#3326A69A',
            success: '#4CAF50',
            warning: '#FF9800',
            error: '#F44336',
            info: '#2196F3'
        },
        previewImage: 'https://dummyimage.com/300x200/1E88E5/FFFFFF&text=Ocean+Breeze'
    },
    {
        id: 'sunset-glow',
        name: 'Sunset Glow',
        description: 'Warm sunset colors with oranges and pinks',
        colors: {
            primary: '#FF6B35',
            secondary: '#F7931E',
            tertiary: '#FFB74D',
            primaryBackground: '#FFF8F0',
            secondaryBackground: '#FFFFFF',
            primaryText: '#2E2E2E',
            secondaryText: '#757575',
            alternate: '#FFF3E0',
            accent1: '#33FF6B35',
            accent2: '#33F7931E',
            accent3: '#33FFB74D',
            success: '#8BC34A',
            warning: '#FFC107',
            error: '#E91E63',
            info: '#00BCD4'
        },
        previewImage: 'https://dummyimage.com/300x200/FF6B35/FFFFFF&text=Sunset+Glow'
    },
    {
        id: 'forest-green',
        name: 'Forest Green',
        description: 'Natural earth tones with greens and browns',
        colors: {
            primary: '#2E7D32',
            secondary: '#388E3C',
            tertiary: '#689F38',
            primaryBackground: '#F1F8E9',
            secondaryBackground: '#FFFFFF',
            primaryText: '#1B5E20',
            secondaryText: '#4E4E4E',
            alternate: '#E8F5E8',
            accent1: '#332E7D32',
            accent2: '#33388E3C',
            accent3: '#33689F38',
            success: '#4CAF50',
            warning: '#FF9800',
            error: '#F44336',
            info: '#2196F3'
        },
        previewImage: 'https://dummyimage.com/300x200/2E7D32/FFFFFF&text=Forest+Green'
    },
    {
        id: 'midnight-purple',
        name: 'Midnight Purple',
        description: 'Dark theme with purple and violet accents',
        colors: {
            primary: '#7B1FA2',
            secondary: '#8E24AA',
            tertiary: '#AB47BC',
            primaryBackground: '#1A0D1F',
            secondaryBackground: '#2D1B2E',
            primaryText: '#FFFFFF',
            secondaryText: '#B39DDB',
            alternate: '#3D2A3F',
            accent1: '#337B1FA2',
            accent2: '#338E24AA',
            accent3: '#33AB47BC',
            success: '#66BB6A',
            warning: '#FFA726',
            error: '#EF5350',
            info: '#42A5F5'
        },
        previewImage: 'https://dummyimage.com/300x200/7B1FA2/FFFFFF&text=Midnight+Purple'
    },
    {
        id: 'golden-hour',
        name: 'Golden Hour',
        description: 'Warm golden tones perfect for productivity',
        colors: {
            primary: '#F57C00',
            secondary: '#FF9800',
            tertiary: '#FFB74D',
            primaryBackground: '#FFFBF0',
            secondaryBackground: '#FFFFFF',
            primaryText: '#3E2723',
            secondaryText: '#6D4C41',
            alternate: '#FFF8E1',
            accent1: '#33F57C00',
            accent2: '#33FF9800',
            accent3: '#33FFB74D',
            success: '#689F38',
            warning: '#FFC107',
            error: '#E53935',
            info: '#1976D2'
        },
        previewImage: 'https://dummyimage.com/300x200/F57C00/FFFFFF&text=Golden+Hour'
    },
    {
        id: 'arctic-blue',
        name: 'Arctic Blue',
        description: 'Cool and clean with icy blue tones',
        colors: {
            primary: '#0277BD',
            secondary: '#0288D1',
            tertiary: '#039BE5',
            primaryBackground: '#F3F9FF',
            secondaryBackground: '#FFFFFF',
            primaryText: '#01579B',
            secondaryText: '#455A64',
            alternate: '#E1F5FE',
            accent1: '#330277BD',
            accent2: '#330288D1',
            accent3: '#33039BE5',
            success: '#00C853',
            warning: '#FF8F00',
            error: '#D32F2F',
            info: '#1976D2'
        },
        previewImage: 'https://dummyimage.com/300x200/0277BD/FFFFFF&text=Arctic+Blue'
    }
];

// In-memory storage for custom themes
let customThemes = [...sampleThemes];

// Routes

// Get all available themes
app.get('/api/themes', (req, res) => {
    console.log(`[${new Date().toISOString()}] GET /api/themes - Fetching all themes`);
    
    const themes = customThemes.map(theme => ({
        id: theme.id,
        name: theme.name,
        description: theme.description,
        previewImage: theme.previewImage
    }));
    
    console.log(`[${new Date().toISOString()}] Returning ${themes.length} themes`);
    
    res.json({
        success: true,
        themes
    });
});

// Get a specific theme by ID
app.get('/api/themes/:id', (req, res) => {
    const { id } = req.params;
    console.log(`[${new Date().toISOString()}] GET /api/themes/${id} - Fetching theme by ID`);
    
    const theme = customThemes.find(t => t.id === id);

    if (!theme) {
        console.log(`[${new Date().toISOString()}] Theme with ID ${id} not found`);
        return res.status(404).json({
            success: false,
            error: 'Theme not found'
        });
    }

    console.log(`[${new Date().toISOString()}] Theme found: ${theme.name}`);
    res.json({
        success: true,
        ...theme
    });
});

// Create a new custom theme
app.post('/api/themes', (req, res) => {
    const { name, description, colors } = req.body;
    console.log(`[${new Date().toISOString()}] POST /api/themes - Creating new theme: ${name}`);
    console.log(`[${new Date().toISOString()}] Theme colors:`, colors);

    if (!name || !colors) {
        console.log(`[${new Date().toISOString()}] Validation failed: missing name or colors`);
        return res.status(400).json({
            success: false,
            error: 'Name and colors are required'
        });
    }

    const newTheme = {
        id: uuidv4(),
        name,
        description: description || '',
        colors,
        previewImage: `https://dummyimage.com/300x200/${colors.primary?.replace('#', '') || '4B39EF'}/FFFFFF&text=${encodeURIComponent(name)}`
    };

    customThemes.push(newTheme);
    console.log(`[${new Date().toISOString()}] Theme created successfully with ID: ${newTheme.id}`);
    console.log(`[${new Date().toISOString()}] Total themes now: ${customThemes.length}`);

    res.status(201).json({
        success: true,
        id: newTheme.id,
        message: 'Theme created successfully'
    });
});

// Update an existing theme
app.put('/api/themes/:id', (req, res) => {
    const { id } = req.params;
    const { name, description, colors } = req.body;
    console.log(`[${new Date().toISOString()}] PUT /api/themes/${id} - Updating theme`);
    console.log(`[${new Date().toISOString()}] Update data:`, { name, description, colors: colors ? 'provided' : 'not provided' });

    const themeIndex = customThemes.findIndex(t => t.id === id);

    if (themeIndex === -1) {
        console.log(`[${new Date().toISOString()}] Theme with ID ${id} not found for update`);
        return res.status(404).json({
            success: false,
            error: 'Theme not found'
        });
    }

    const oldTheme = customThemes[themeIndex];
    customThemes[themeIndex] = {
        ...customThemes[themeIndex],
        name: name || customThemes[themeIndex].name,
        description: description !== undefined ? description : customThemes[themeIndex].description,
        colors: colors || customThemes[themeIndex].colors
    };

    console.log(`[${new Date().toISOString()}] Theme updated: ${oldTheme.name} -> ${customThemes[themeIndex].name}`);
    res.json({
        success: true,
        message: 'Theme updated successfully'
    });
});

// Delete a theme
app.delete('/api/themes/:id', (req, res) => {
    const { id } = req.params;
    console.log(`[${new Date().toISOString()}] DELETE /api/themes/${id} - Deleting theme`);

    const themeIndex = customThemes.findIndex(t => t.id === id);

    if (themeIndex === -1) {
        console.log(`[${new Date().toISOString()}] Theme with ID ${id} not found for deletion`);
        return res.status(404).json({
            success: false,
            error: 'Theme not found'
        });
    }

    const deletedTheme = customThemes[themeIndex];
    customThemes.splice(themeIndex, 1);
    console.log(`[${new Date().toISOString()}] Theme deleted: ${deletedTheme.name}`);
    console.log(`[${new Date().toISOString()}] Total themes now: ${customThemes.length}`);

    res.json({
        success: true,
        message: 'Theme deleted successfully'
    });
});

// Get theme categories or featured themes
app.get('/api/themes/featured', (req, res) => {
    console.log(`[${new Date().toISOString()}] GET /api/themes/featured - Fetching featured themes`);
    
    const featured = customThemes.slice(0, 3);
    console.log(`[${new Date().toISOString()}] Returning ${featured.length} featured themes`);
    
    res.json({
        success: true,
        themes: featured
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    console.log(`[${new Date().toISOString()}] GET /health - Health check requested`);
    
    const healthData = {
        status: 'OK',
        timestamp: new Date().toISOString(),
        themes: customThemes.length
    };
    
    console.log(`[${new Date().toISOString()}] Health check: ${healthData.status}, ${healthData.themes} themes`);
    
    res.json(healthData);
});

// Error handling middleware
app.use((err, req, res, next) => {
    const timestamp = new Date().toISOString();
    console.error(`[${timestamp}] ERROR: ${err.message}`);
    console.error(`[${timestamp}] Stack trace:`, err.stack);
    console.error(`[${timestamp}] Request: ${req.method} ${req.path}`);
    
    res.status(500).json({
        success: false,
        error: 'Something went wrong!'
    });
});

// 404 handler
app.use((req, res) => {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] 404 - Route not found: ${req.method} ${req.path}`);
    
    res.status(404).json({
        success: false,
        error: 'Route not found'
    });
});

app.listen(PORT, () => {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] 🎨 Theme API Server starting up...`);
    console.log(`[${timestamp}] 📍 Server running on port ${PORT}`);
    console.log(`[${timestamp}] 📋 Available endpoints:`);
    console.log(`[${timestamp}]    GET    /api/themes          - List all themes`);
    console.log(`[${timestamp}]    GET    /api/themes/:id      - Get specific theme`);
    console.log(`[${timestamp}]    POST   /api/themes          - Create new theme`);
    console.log(`[${timestamp}]    PUT    /api/themes/:id      - Update theme`);
    console.log(`[${timestamp}]    DELETE /api/themes/:id      - Delete theme`);
    console.log(`[${timestamp}]    GET    /api/themes/featured - Get featured themes`);
    console.log(`[${timestamp}]    GET    /health              - Health check`);
    console.log(`[${timestamp}] 🚀 Server ready to accept requests!`);
});