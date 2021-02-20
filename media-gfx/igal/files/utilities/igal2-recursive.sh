#
find $1 -type d -xdev ! -name "\.igal" -exec igal2 -n --bigy 510 -xy 140 --dest ".igal" --AddSubdir -u -www -pagination 50 -d "{}" \;
