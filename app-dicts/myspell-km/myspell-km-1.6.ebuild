# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-km/myspell-km-1.6.ebuild,v 1.1 2012/07/23 14:15:41 scarabeus Exp $

EAPI=4

MYSPELL_DICT=(
	"km_KH.aff"
	"km_KH.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Khmer dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/khmer-spelling-checker-sbbic-version"
SRC_URI="http://extensions.libreoffice.org/extension-center/khmer-spelling-checker-sbbic-version/releases/${PV}/sbbic-khmer-spelling-checker-${PV}.oxt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
