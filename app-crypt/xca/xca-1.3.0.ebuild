# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="A GUI to OpenSSL, RSA public keys, certificates, signing requests and revokation lists"
HOMEPAGE="http://xca.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="bindist"

RDEPEND=">=dev-libs/openssl-0.9.8:*[bindist=]
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.0-desktop.patch
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
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
