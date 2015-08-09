# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit eutils multilib toolchain-funcs user

DESCRIPTION="Yet another Dictionary server for the SKK Japanese-input software"
HOMEPAGE="http://dbskkd-cdb.googlecode.com/"
SRC_URI="http://dbskkd-cdb.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="|| ( dev-db/cdb dev-db/tinycdb )"
RDEPEND=">=app-i18n/skk-jisyo-200705[cdb]
	sys-apps/xinetd"

pkg_setup() {
	enewuser dbskkd -1 -1 -1
}

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"
	sed -i -e "/^CDBLIB/s:lib:$(get_libdir):" Makefile || die
	if has_version dev-db/cdb ; then
		sed -i -e "/^CDBLIB/s:$: /usr/$(get_libdir)/byte.a /usr/$(get_libdir)/unix.a:" Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	insinto /etc/xinetd.d
	newins "${FILESDIR}/${PN}.xinetd" ${PN} || die

	dodoc CHANGES README* *.txt
}
