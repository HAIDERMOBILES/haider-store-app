HAIDER STORE APP - API CONNECTED STARTER

Is package mein Flutter Android app ka starter ab live website API se connect hai.

Connected API:
- https://haiderstore.shop/api/themes.php (admin-selected theme)
- https://haiderstore.shop/api/categories.php
- https://haiderstore.shop/api/products.php

Product images filhal website ke /uploads/ folder se load hoti hain.

IMPORTANT:
1. Is ZIP ko extract karein.
2. Flutter project ke taur par 64-bit Windows PC ya cloud build environment mein open karein.
3. Terminal mein `flutter pub get` chalayein.
4. Android device/emulator par `flutter run` chalayein.
5. APK banane ke liye `flutter build apk --release` use hota hai.

Aapke current 32-bit Windows PC par Flutter build locally nahi ho sakega. Is liye is project ko 64-bit PC ya cloud build service par build karna hoga.

NOTE:
Yeh phase Home screen par live products, categories aur admin-selected theme load karta hai. Login, registration, cart, checkout, orders aur banners ke native app APIs aglay phases mein implement honge. Website ka existing PHP system is package se modify nahi hota.
