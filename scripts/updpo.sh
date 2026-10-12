#!/bin/bash

# Generate messages.po
xgettext src/unios-update.sh src/lib/* src/tray/src/*.rs

# Normalize messages.po
# shellcheck disable=SC2016
sed -i '/^#:.*$/N;/\nmsgid "\$(\(echo -e\|info_msg\) "/,/msgstr ""/d' messages.po
sed -i '/^$/N;/^\n$/D' messages.po
sed -i '1,/^#: src\//{ /^#: src\//!d }' messages.po

# Merge messages.po into unios-update.pot
sed -i -e '/^#: src\//,$d' po/unios-update.pot
cat messages.po >> po/unios-update.pot
rm -f messages.po

# Merge changes in po files
for po in po/*.po; do
	msgmerge "${po}" "po/unios-update.pot" -o "${po}"
done
