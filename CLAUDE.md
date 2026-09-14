# YINKS App — Agent Rules

## Project Structure
This is a Flutter app using feature-first clean architecture.
- lib/core/ — shared theme, widgets, utils
- lib/features/<feature_name>/ — each feature has data/, domain/, presentation/

## Theme
Use only colors and fonts defined in lib/core/theme/app_colors.dart and 
app_text_styles.dart (Amethyst Silk Atelier design system). Never hardcode 
colors or fonts directly in a screen or widget.

## STRICT RULES FOR EVERY TASK

1. Only edit the file(s) I explicitly mention in my request.
2. Never modify, refactor, or "clean up" files in other feature folders 
   unless I explicitly ask.
3. Never delete existing code unless I explicitly ask you to.
4. If a task seems to require touching a file I did not mention, STOP 
   and ask me first before making that change.
5. After completing any task, list every file you created or modified, 
   with a one-line reason for each.
6. Do not add new packages/dependencies without asking first.
7. Do not create placeholder/dummy features I did not request.

## Backend
No real backend (Firebase) integration yet. Use mock/abstract repositories 
(interfaces) for anything that will later connect to a backend, so the 
real implementation can be swapped in later without changing UI code.

## Responsive Foundation
The app uses flutter_screenutil for responsive sizing, initialized in 
main.dart via ScreenUtilInit with design size 375x812.

- All screens must use flutter_screenutil (.w/.h/.sp) for sizing — no 
  fixed pixel values.
- All screens must wrap their main content in 
  lib/core/widgets/responsive_wrapper.dart's ResponsiveWrapper so tablet 
  layouts stay safe by default.