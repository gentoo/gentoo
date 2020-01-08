# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"is.aff"
	"is.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Icelandic dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/hunspell-is-the-icelandic-spelling-dictionary-project"
SRC_URI="http://extensions.libreoffice.org/extension-center/hunspell-is-the-icelandic-spelling-dictionary-project/releases/${PV}/hunspell-is-${PV}.oxt"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""
