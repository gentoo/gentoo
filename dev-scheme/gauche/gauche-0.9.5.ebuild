# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils

MY_P="${P^g}"

DESCRIPTION="A Unix system friendly Scheme Interpreter"
HOMEPAGE="http://practical-scheme.net/gauche/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="ipv6 libressl test"

RDEPEND="sys-libs/gdbm"
DEPEND="${RDEPEND}
	test? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-rpath.patch
	epatch "${FILESDIR}"/${PN}-gauche.m4.patch
	epatch "${FILESDIR}"/${PN}-ext-ldflags.patch
	epatch "${FILESDIR}"/${PN}-xz-info.patch
	epatch "${FILESDIR}"/${PN}-rfc.tls.patch
	epatch "${FILESDIR}"/${P}-libressl.patch
	epatch "${FILESDIR}"/${P}-bsd.patch
	epatch "${FILESDIR}"/${P}-main.patch
	epatch "${FILESDIR}"/${P}-unicode.patch
	eapply_user

	use ipv6 && sed -i "s/ -4//" ext/tls/ssltest-mod.scm

	eautoconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		--with-libatomic-ops=no \
		--with-slib="${EPREFIX}"/usr/share/slib
}

src_test() {
	emake -j1 -s check
}

src_install() {
	emake DESTDIR="${D}" install-pkg install-doc
	dodoc AUTHORS ChangeLog HACKING README
}
