# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Type the regexp and visualize it on a sample of your choice"
HOMEPAGE="http://laurent.riesterer.free.fr/regexp/"
SRC_URI="
	http://dev.gentoo.org/~jlec/distfiles/visualregexp-icon.png.tar
	http://laurent.riesterer.free.fr/regexp/visual_regexp-${PV}.tcl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/tk-8.5"

S="${WORKDIR}"

src_unpack() {
	# Manually copy the source file since unpack gets confused by things it can't unpack
	cp "${DISTDIR}/visual_regexp-${PV}.tcl" "${WORKDIR}/visual_regexp.tcl"

	default
}

src_prepare() {
	# File comes with DOS newlines
	edos2unix visual_regexp.tcl

	epatch \
		"${FILESDIR}/${P}-wish-fix.patch" \
		"${FILESDIR}/${P}-help-font-fix.patch" \
		"${FILESDIR}/${P}-make-regexp-fix.patch" \
		"${FILESDIR}/${PN}-3.0-home-conf-fix.patch" \
		"${FILESDIR}/${PN}-3.0-pattern-load-fix.patch"

	epatch_user
}

src_install() {
	newbin visual_regexp.tcl visualregexp
	dosym visualregexp /usr/bin/tkregexp
	doicon "${WORKDIR}/visualregexp-icon.png"
	domenu "${FILESDIR}/visualregexp.desktop"
}
