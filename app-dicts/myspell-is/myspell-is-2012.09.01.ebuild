# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-is/myspell-is-2012.09.01.ebuild,v 1.11 2013/02/07 21:22:30 ulm Exp $

EAPI=4

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
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
