# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/gauche/gauche-0.9.4.ebuild,v 1.1 2014/09/07 03:26:06 hattya Exp $

EAPI="5"

inherit autotools eutils

MY_P="${P^g}"

DESCRIPTION="A Unix system friendly Scheme Interpreter"
HOMEPAGE="http://practical-scheme.net/gauche/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="ipv6 test"

RDEPEND="sys-libs/gdbm"
DEPEND="${RDEPEND}
	test? ( dev-libs/openssl )"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-rpath.diff
	epatch "${FILESDIR}"/${PN}-gauche.m4.diff
	epatch "${FILESDIR}"/${PN}-ext-ldflags.diff
	epatch "${FILESDIR}"/${PN}-xz-info.diff
	epatch "${FILESDIR}"/${PN}-rfc.tls.diff
	eautoconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		--with-slib="${EPREFIX}"/usr/share/slib
}

src_test() {
	emake -j1 -s check
}

src_install() {
	emake -j1 DESTDIR="${D}" install-pkg install-doc
	dodoc AUTHORS ChangeLog HACKING README
}
