# Matrimonial iOS App

##Setup Instructions
use **development** branch
git clone https://github.com/akashswansi/Matrimonial.git
cd Matrimonial
git checkout development
open Matrimonial.xcodeproj

##SPM with Xcode
use this command to resolve dependencies
xcodebuild -resolvePackageDependencies

OR
 
# Add package
swift package add https://github.com/SDWebImage/SDWebImageSwiftUI.git

# Update packages
swift package update

# Resolve dependencies
swift package resolve

# List all packages
swift package show-dependencies

# Clean cache (fix issues)
rm -rf ~/Library/Caches/org.swift.swiftpm
