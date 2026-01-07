# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop edos2unix

DESCRIPTION="Type the regexp and visualize it on a sample of your choice"
HOMEPAGE="http://laurent.riesterer.free.fr/regexp/"
SRC_URI="
	https://dev.gentoo.org/~jlec/distfiles/visualregexp-icon.png.tar
	http://laurent.riesterer.free.fr/regexp/visual_regexp-${PV}.tcl"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-lang/tk-8.5"

PATCHES=(
	"${FILESDIR}"/${P}-wish-fix.patch
	"${FILESDIR}"/${P}-help-font-fix.patch
	"${FILESDIR}"/${P}-make-regexp-fix.patch
	"${FILESDIR}"/${PN}-3.0-home-conf-fix.patch
	"${FILESDIR}"/${PN}-3.0-pattern-load-fix.patch
)

src_unpack() {
	# Manually copy the source file since unpack gets confused by things it can't unpack
	cp "${DISTDIR}/visual_regexp-${PV}.tcl" "${WORKDIR}/visual_regexp.tcl"

	default
}

src_prepare() {
	# File comes with DOS newlines
	edos2unix visual_regexp.tcl

	default
}

src_install() {
	newbin visual_regexp.tcl visualregexp
	dosym visualregexp /usr/bin/tkregexp
	doicon "${WORKDIR}/visualregexp-icon.png"
	domenu "${FILESDIR}/visualregexp.desktop"
}
