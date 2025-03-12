default:
    just --list

# Runs the example.
dev:
    cd example && dashmon

pub-verify:
    flutter pub publish --dry-run

# I'll just document the steps I did to make this project lol. Mostly used AI:
# 1. Created the flutter project with `flutter create --template=package sonenr_flutter`
# 2. Created an `example` folder for debugging: `mkdir example && flutter create .`
# 3. Developed it :D (with AI)
# 4. flutter pub publish --dry-run
