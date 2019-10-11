# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"da_DK.aff"
	"da_DK.dic"
)

MYSPELL_HYPH=(
	"hyph_da_DK.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Danish dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/stavekontrolden-danish-dictionary"
SRC_URI="https://extensions.libreoffice.org/extension-center/stavekontrolden-danish-dictionary/pscreleasefolder.2011-09-30.0280139318/2.1/dict-da-${PV}.oxt"
SRC_URI="https://extensions.libreoffice.org/extensions/stavekontrolden-danish-dictionary/${PV}/@@download/file/dict-da-${PV/./-}.oxt"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""
