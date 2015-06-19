# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/ibam/ibam-0.5.2-r3.ebuild,v 1.2 2012/05/02 20:22:38 jdhore Exp $

EAPI=4

PATCH_LEVEL=2

inherit eutils multilib toolchain-funcs

DESCRIPTION="Intelligent Battery Monitor"
HOMEPAGE="http://ibam.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${PATCH_LEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gkrellm"

RDEPEND="
	gkrellm? (
		app-admin/gkrellm
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
	)"
DEPEND="
	${RDEPEND}
	gkrellm? ( virtual/pkgconfig )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${WORKDIR}"/${PN}_${PV}-${PATCH_LEVEL}.diff

	local f
	for f in `find . -name '*.dpatch'`; do
		epatch ${f}
	done
}

src_compile() {
	tc-export CXX
	emake
	use gkrellm && emake krell
}

src_install() {
	dobin ibam
	dodoc CHANGES README REPORT

	if use gkrellm; then
		insinto /usr/$(get_libdir)/gkrellm2/plugins
		doins ibam-krell.so
	fi
}

pkg_postinst() {
	elog
	elog "You will need to install sci-visualization/gnuplot if you wish to use"
	elog "the --plot argument to ibam."
	elog
}
