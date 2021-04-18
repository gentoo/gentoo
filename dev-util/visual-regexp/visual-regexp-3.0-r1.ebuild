# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit desktop epatch

DESCRIPTION="Type the regexp and visualize it on a sample of your choice"
HOMEPAGE="http://laurent.riesterer.free.fr/regexp/"
SRC_URI="
	https://dev.gentoo.org/~jlec/distfiles/visualregexp-icon.png.tar
	http://laurent.riesterer.free.fr/regexp/visual_regexp-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/tk-8.3"

S=${WORKDIR}/visual_regexp-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-wish-fix.patch \
		"${FILESDIR}"/${P}-help-font-fix.patch \
		"${FILESDIR}"/${P}-home-conf-fix.patch \
		"${FILESDIR}"/${P}-pattern-load-fix.patch
}

src_install() {
	dodoc README

	newbin visual_regexp.tcl visualregexp

	dosym visualregexp /usr/bin/tkregexp

	doicon "${WORKDIR}"/visualregexp-icon.png

	domenu "${FILESDIR}"/visualregexp.desktop
}
