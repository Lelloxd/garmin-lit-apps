#!/bin/bash
# Build script for Golf Range app
# Make sure you have Garmin Connect IQ SDK installed

echo "Building Golf Range for Vivoactive 3..."
echo ""

# Check if GARMIN_HOME is set
if [ -z "$GARMIN_HOME" ]; then
    echo "ERROR: GARMIN_HOME environment variable not set"
    echo "Please set GARMIN_HOME to your Garmin Connect IQ SDK installation directory"
    echo "Example: export GARMIN_HOME=/opt/garmin/connect-iq-sdk"
    exit 1
fi

# Create bin directory if it doesn't exist
mkdir -p "$(dirname "$0")/bin"

# Compile the app
echo "Compiling Monkey C code..."
"${GARMIN_HOME}/bin/monkeyc" \
    -d vivoactive3 \
    -f "$(dirname "$0")/build.properties" \
    -o "$(dirname "$0")/bin/GolfRange.prg" \
    -w \
    -z \
    "$(dirname "$0")/source" "$(dirname "$0")/resources"

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Build failed!"
    exit 1
fi

echo ""
echo "Build completed successfully!"
echo "Output: $(dirname "$0")/bin/GolfRange.prg"
echo ""
echo "Next steps:"
echo "1. Install the app on your Vivoactive 3 using the Connect IQ App Store"
echo "   or via the Garmin Connect IQ Simulator"
echo "2. Test on the device and adjust SWING_THRESHOLD if needed"
echo ""
