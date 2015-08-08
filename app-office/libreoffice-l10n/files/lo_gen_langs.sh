#!/bin/bash
# Licensed under the GNU General Public License, v2

#
# Author: Ralph Sennhauser
#
# Find l10n packs for libreoffice and format it for use in ebuilds.
#

VERSION=${1:-4.1.5}
BASE_SRC_URI="http://download.documentfoundation.org/libreoffice/stable/${VERSION}/rpm/x86"

# needs lxml
print_available_tarballs() {
	python << EOL
import sys, urllib
from xml.dom.minidom import parseString
from BeautifulSoup import BeautifulSoup

opener = urllib.urlopen("${BASE_SRC_URI}")
html = opener.read()
opener.close()
# broken html, try to sanitize
html = BeautifulSoup(html).prettify()

dom = parseString(html)
for elem in dom.getElementsByTagName('a'):
	attr = elem.getAttribute("href")
	if attr.endswith('tar.gz'): 
		if "install" in attr: continue
		print(attr)
EOL
}

tarballs=( $(print_available_tarballs) )
help_packs=()
lang_packs=()
lang_packs_reduced=()

for tb in "${tarballs[@]}"; do
	pack=${tb%.tar.gz}
	pack=${pack##*rpm_}
	pack=${pack/en-US/en}
	pack=${pack/-/_}
	pack=${pack/en-US/en}
	if [[ ${tb} =~ helppack ]]; then
		pack=${pack/helppack_/}
		help_packs+=( ${pack} )
	elif [[ ${tb} =~ langpack ]]; then
		pack=${pack/langpack_/}
		lang_packs+=( ${pack} )
	fi
done

for lpack in "${lang_packs[@]}"; do
	for hpack in "${help_packs[@]}"; do
		if [[ ${hpack} == ${lpack} ]]; then
			continue 2
		fi
	done
	lang_packs_reduced+=( ${lpack} )
done

echo "LANGUAGES_HELP=\" ${help_packs[@]} \""
echo "LANGUAGES=\"\${LANGUAGES_HELP}${lang_packs_reduced[@]} \""
