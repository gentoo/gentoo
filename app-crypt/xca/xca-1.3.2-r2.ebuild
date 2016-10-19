# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs autotools

DESCRIPTION="A GUI to OpenSSL, RSA public keys, certificates, signing requests etc"
HOMEPAGE="http://xca.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="bindist doc libressl qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	!libressl? ( dev-libs/openssl:0=[bindist=] )
	libressl? ( dev-libs/libressl:0= )
	doc? ( app-text/linuxdoc-tools )
	qt5? ( dev-qt/qtgui:5 )
	qt4? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.0-desktop.patch
	epatch "${FILESDIR}"/${P}-build.patch
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	# bug #595440
	use qt5 && append-cxxflags -std=c++11
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-qt-version=$(use qt5 && echo 5 || echo 4) \
		$(use_enable doc) \
		STRIP=true
}

src_compile() {
	# enforce all to avoid the automatic silent rules
	emake all
}

src_install() {
	# non standard destdir
	emake install destdir="${ED}"

	insinto /etc/xca
	doins misc/*.txt
}
