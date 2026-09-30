#!/bin/bash
echo "Установка Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Сборка проекта..."
flutter config --enable-web
flutter pub get
flutter build web --release
