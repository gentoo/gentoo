# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/irsim/irsim-9.7.79.ebuild,v 1.3 2015/03/20 15:26:36 jlec Exp $

EAPI=4

inherit eutils multilib

DESCRIPTION="IRSIM is a \"switch-level\" simulator"
HOMEPAGE="http://opencircuitdesign.com/irsim/"
SRC_URI="http://opencircuitdesign.com/irsim/archive/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/tcl:0
	dev-lang/tk:0"
DEPEND="${RDEPEND}
	app-shells/tcsh"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-9.7.72-ldflags.patch
	epatch "${FILESDIR}"/${PN}-9.7.79-datadir.patch
	sed -e "s:/usr/bin/:${EPREFIX}/usr/bin/:" \
		-e "s:/usr/local/lib/:${EPREFIX}/usr/$(get_libdir)/:" \
		-i tcltk/irsim.sh \
		-i tcltk/irsim.tcl || die
}

src_configure() {
	# Short-circuit top-level configure script to retain CFLAGS
	cd scripts
	#tc-export CPP
	econf
}

src_install() {
	emake DESTDIR="${D}" DOCDIR=/usr/share/doc/${PF} install
	dodoc README
}

pkg_postinst() {
	einfo
	einfo "You will probably need to add to your ~/.Xdefaults"
	einfo "the following line:"
	einfo "irsim.background: black"
	einfo
	einfo "This is needed because Gentoo from default sets a"
	einfo "grey background which makes impossible to see the"
	einfo "simulation (white line on light gray background)."
	einfo
}
