const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');
const path = require('path');
const fs = require('fs');

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
            primary: '#ff1e88e5',
            secondary: '#ff00acc1',
            tertiary: '#ff26a69a',
            primaryBackground: '#fff0f8ff',
            secondaryBackground: '#ffffffff',
            primaryText: '#ff1a1a1a',
            secondaryText: '#ff666666',
            alternate: '#ffe3f2fd',
            accent1: '#331e88e5',
            accent2: '#3300acc1',
            accent3: '#3326a69a',
            success: '#ff4caf50',
            warning: '#ffff9800',
            error: '#fff44336',
            info: '#ff2196f3'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/1E88E5/FFFFFF&text=Ocean+Breeze'
    },
    {
        id: 'sunset-glow',
        name: 'Sunset Glow',
        description: 'Warm sunset colors with oranges and pinks',
        colors: {
            primary: '#ffff6b35',
            secondary: '#fff7931e',
            tertiary: '#ffffb74d',
            primaryBackground: '#fffff8f0',
            secondaryBackground: '#ffffffff',
            primaryText: '#ff2e2e2e',
            secondaryText: '#ff757575',
            alternate: '#fffff3e0',
            accent1: '#33ff6b35',
            accent2: '#33f7931e',
            accent3: '#33ffb74d',
            success: '#ff8bc34a',
            warning: '#ffffc107',
            error: '#ffe91e63',
            info: '#ff00bcd4'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/FF6B35/FFFFFF&text=Sunset+Glow'
    },
    {
        id: 'forest-green',
        name: 'Forest Green',
        description: 'Natural earth tones with greens and browns',
        colors: {
            primary: '#ff2e7d32',
            secondary: '#ff388e3c',
            tertiary: '#ff689f38',
            primaryBackground: '#fff1f8e9',
            secondaryBackground: '#ffffffff',
            primaryText: '#ff1b5e20',
            secondaryText: '#ff4e4e4e',
            alternate: '#ffe8f5e8',
            accent1: '#332e7d32',
            accent2: '#33388e3c',
            accent3: '#33689f38',
            success: '#ff4caf50',
            warning: '#ffff9800',
            error: '#fff44336',
            info: '#ff2196f3'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/2E7D32/FFFFFF&text=Forest+Green'
    },
    {
        id: 'midnight-purple',
        name: 'Midnight Purple',
        description: 'Dark theme with purple and violet accents',
        colors: {
            primary: '#ff7b1fa2',
            secondary: '#ff8e24aa',
            tertiary: '#ffab47bc',
            primaryBackground: '#ff1a0d1f',
            secondaryBackground: '#ff2d1b2e',
            primaryText: '#ffffffff',
            secondaryText: '#ffb39ddb',
            alternate: '#ff3d2a3f',
            accent1: '#337b1fa2',
            accent2: '#338e24aa',
            accent3: '#33ab47bc',
            success: '#ff66bb6a',
            warning: '#ffffa726',
            error: '#ffef5350',
            info: '#ff42a5f5'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/7B1FA2/FFFFFF&text=Midnight+Purple'
    },
    {
        id: 'golden-hour',
        name: 'Golden Hour',
        description: 'Warm golden tones perfect for productivity',
        colors: {
            primary: '#fff57c00',
            secondary: '#ffff9800',
            tertiary: '#ffffb74d',
            primaryBackground: '#fffffbf0',
            secondaryBackground: '#ffffffff',
            primaryText: '#ff3e2723',
            secondaryText: '#ff6d4c41',
            alternate: '#fffff8e1',
            accent1: '#33f57c00',
            accent2: '#33ff9800',
            accent3: '#33ffb74d',
            success: '#ff689f38',
            warning: '#ffffc107',
            error: '#ffe53935',
            info: '#ff1976d2'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/F57C00/FFFFFF&text=Golden+Hour'
    },
    {
        id: 'arctic-blue',
        name: 'Arctic Blue',
        description: 'Cool and clean with icy blue tones',
        colors: {
            primary: '#ff0277bd',
            secondary: '#ff0288d1',
            tertiary: '#ff039be5',
            primaryBackground: '#fff3f9ff',
            secondaryBackground: '#ffffffff',
            primaryText: '#ff01579b',
            secondaryText: '#ff455a64',
            alternate: '#ffe1f5fe',
            accent1: '#330277bd',
            accent2: '#330288d1',
            accent3: '#33039be5',
            success: '#ff00c853',
            warning: '#ffff8f00',
            error: '#ffd32f2f',
            info: '#ff1976d2'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "Inter", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "Inter", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "Inter", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "Inter", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/0277BD/FFFFFF&text=Arctic+Blue'
    },
    {
        id: 'roboto-modern',
        name: 'Roboto Modern',
        description: 'Clean modern theme with Roboto font family',
        colors: {
            primary: '#ff1976d2',
            secondary: '#ff2196f3',
            tertiary: '#ff03a9f4',
            primaryBackground: '#fffafafa',
            secondaryBackground: '#ffffffff',
            primaryText: '#ff212121',
            secondaryText: '#ff757575',
            alternate: '#fff5f5f5',
            accent1: '#331976d2',
            accent2: '#332196f3',
            accent3: '#3303a9f4',
            success: '#ff4caf50',
            warning: '#ffff9800',
            error: '#fff44336',
            info: '#ff00bcd4'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "Roboto", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "Roboto", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "Roboto", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "Roboto", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "Roboto", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "Roboto", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "Roboto", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "Roboto", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "Roboto", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "Roboto", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "Roboto", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "Roboto", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "Roboto", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "Roboto", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "Roboto", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "Roboto", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "Roboto", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "Roboto", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "Roboto", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "Roboto", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "Roboto", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "Roboto", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/1976D2/FFFFFF&text=Roboto+Modern'
    },
    {
        id: 'opensans-elegant',
        name: 'OpenSans Elegant',
        description: 'Elegant theme with OpenSans font family',
        colors: {
            primary: '#ff673ab7',
            secondary: '#ff9c27b0',
            tertiary: '#ffe91e63',
            primaryBackground: '#fffce4ec',
            secondaryBackground: '#ffffffff',
            primaryText: '#ff311b92',
            secondaryText: '#ff6a1b9a',
            alternate: '#fff3e5f5',
            accent1: '#33673ab7',
            accent2: '#339c27b0',
            accent3: '#33e91e63',
            success: '#ff4caf50',
            warning: '#ffff9800',
            error: '#fff44336',
            info: '#ff2196f3'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "OpenSans", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "OpenSans", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "OpenSans", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "OpenSans", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "OpenSans", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "OpenSans", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "OpenSans", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "OpenSans", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "OpenSans", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "OpenSans", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "OpenSans", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "OpenSans", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "OpenSans", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "OpenSans", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "OpenSans", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "OpenSans", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "OpenSans", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "OpenSans", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "OpenSans", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "OpenSans", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "OpenSans", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "OpenSans", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/673AB7/FFFFFF&text=OpenSans+Elegant'
    },
    {
        id: 'montserrat-modern',
        name: 'Montserrat Modern',
        description: 'Modern and elegant theme with Montserrat font family',
        colors: {
            primary: '#ff2e63',
            secondary: '#ff6b9d',
            tertiary: '#ff8fab',
            primaryBackground: '#fffafafa',
            secondaryBackground: '#ffffffff',
            primaryText: '#ff2c3e50',
            secondaryText: '#ff7f8c8d',
            alternate: '#fff5f5f5',
            accent1: '#332e63',
            accent2: '#336b9d',
            accent3: '#338fab',
            success: '#ff27ae60',
            warning: '#fff39c12',
            error: '#ffe74c3c',
            info: '#ff3498db'
        },
        typography: [
            { "name": "Display XL", "fontFamily": "Montserrat", "fontWeight": "Bold", "fontSize": 32, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display L", "fontFamily": "Montserrat", "fontWeight": "Bold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Display M", "fontFamily": "Montserrat", "fontWeight": "Bold", "fontSize": 20, "letterSpacing": { "unit": "PIXELS", "value": 0 } },
            { "name": "Display S", "fontFamily": "Montserrat", "fontWeight": "Bold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXXL", "fontFamily": "Montserrat", "fontWeight": "SemiBold", "fontSize": 24, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XXL", "fontFamily": "Montserrat", "fontWeight": "SemiBold", "fontSize": 20, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading XL", "fontFamily": "Montserrat", "fontWeight": "SemiBold", "fontSize": 18, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading L", "fontFamily": "Montserrat", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading M", "fontFamily": "Montserrat", "fontWeight": "SemiBold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Medium", "fontFamily": "Montserrat", "fontWeight": "Medium", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Heading S-Semi Bold", "fontFamily": "Montserrat", "fontWeight": "SemiBold", "fontSize": 12, "letterSpacing": { "unit": "PIXELS", "value": 1 } },
            { "name": "Body L-Bold", "fontFamily": "Montserrat", "fontWeight": "Bold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Semi Bold", "fontFamily": "Montserrat", "fontWeight": "SemiBold", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Medium", "fontFamily": "Montserrat", "fontWeight": "Medium", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body L-Regular", "fontFamily": "Montserrat", "fontWeight": "Regular", "fontSize": 16, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Bold", "fontFamily": "Montserrat", "fontWeight": "Bold", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body M-Regular", "fontFamily": "Montserrat", "fontWeight": "Regular", "fontSize": 14, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Bold", "fontFamily": "Montserrat", "fontWeight": "Bold", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Medium", "fontFamily": "Montserrat", "fontWeight": "Medium", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body S-Regular", "fontFamily": "Montserrat", "fontWeight": "Regular", "fontSize": 12, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Regular", "fontFamily": "Montserrat", "fontWeight": "Regular", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } },
            { "name": "Body XS-Medium", "fontFamily": "Montserrat", "fontWeight": "Medium", "fontSize": 10, "letterSpacing": { "unit": "PERCENT", "value": 0 } }
        ],
        previewImage: 'https://dummyimage.com/300x200/2E63FF/FFFFFF&text=Montserrat+Modern'
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

// Font serving endpoint
app.get('/api/fonts/:fontFamily/:fontWeight', (req, res) => {
    const { fontFamily, fontWeight } = req.params;
    console.log(`[${new Date().toISOString()}] GET /api/fonts/${fontFamily}/${fontWeight} - Serving font file`);
    
    // Generate dynamic file name from request parameters
    // Convert font family to proper case and replace spaces with hyphens
    const formattedFontFamily = fontFamily
        .split(' ')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
        .join('-');
    
    // Convert font weight to proper case and replace spaces with hyphens
    const formattedFontWeight = fontWeight
        .split(' ')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
        .join('-');
    
    // Generate the expected file name
    const fileName = `${formattedFontFamily}-${formattedFontWeight}`;
    const fontPath = path.join(__dirname, 'fonts', `${fileName}.ttf`);
    
    console.log(`[${new Date().toISOString()}] Looking for font file: ${fontPath}`);
    
    // Check if font file exists
    if (fs.existsSync(fontPath)) {
        console.log(`[${new Date().toISOString()}] Serving font file: ${fontPath}`);
        
        // Set appropriate headers for font files
        res.setHeader('Content-Type', 'font/ttf');
        res.setHeader('Cache-Control', 'public, max-age=31536000'); // Cache for 1 year
        res.setHeader('Access-Control-Allow-Origin', '*');
        
        // Send the font file
        res.sendFile(fontPath);
    } else {
        console.log(`[${new Date().toISOString()}] Font file not found: ${fontPath}`);
        
        // Try to find alternative font files in the directory
        const fontsDir = path.join(__dirname, 'fonts');
        const availableFonts = fs.readdirSync(fontsDir)
            .filter(file => file.endsWith('.ttf'))
            .map(file => file.replace('.ttf', ''));
        
        console.log(`[${new Date().toISOString()}] Available fonts: ${availableFonts.join(', ')}`);
        
        res.status(404).json({
            success: false,
            error: 'Font file not found',
            message: `Font ${fontFamily} ${fontWeight} is not available`,
            requestedFile: `${fileName}.ttf`,
            availableFonts: availableFonts,
            suggestion: `Expected format: ${formattedFontFamily}-${formattedFontWeight}.ttf`
        });
    }
});

// List available fonts endpoint
app.get('/api/fonts', (req, res) => {
    console.log(`[${new Date().toISOString()}] GET /api/fonts - Listing available fonts`);
    
    try {
        const fontsDir = path.join(__dirname, 'fonts');
        const availableFonts = fs.readdirSync(fontsDir)
            .filter(file => file.endsWith('.ttf'))
            .map(file => {
                const fileName = file.replace('.ttf', '');
                // Parse font name and weight from filename
                const parts = fileName.split('-');
                const weight = parts.pop();
                const family = parts.join('-');
                
                return {
                    fileName: file,
                    family: family,
                    weight: weight,
                    fullName: fileName
                };
            });
        
        console.log(`[${new Date().toISOString()}] Found ${availableFonts.length} font files`);
        
        res.json({
            success: true,
            fonts: availableFonts,
            count: availableFonts.length
        });
    } catch (error) {
        console.error(`[${new Date().toISOString()}] Error reading fonts directory:`, error);
        res.status(500).json({
            success: false,
            error: 'Failed to read fonts directory',
            message: error.message
        });
    }
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
    console.log(`[${timestamp}]    GET    /api/fonts           - List available fonts`);
    console.log(`[${timestamp}]    GET    /api/fonts/:family/:weight - Serve font file`);
    console.log(`[${timestamp}]    GET    /health              - Health check`);
    console.log(`[${timestamp}] 🚀 Server ready to accept requests!`);
});