# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit user tmpfiles

PATCH_VER="1.0"

DESCRIPTION="Weighted Policy daemon for Postfix"
HOMEPAGE="http://www.policyd-weight.org/"
SRC_URI="http://www.policyd-weight.org/releases/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.xz
	https://dev.gentoo.org/~whissi/dist/${PN}/${P}-patches-${PATCH_VER}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/perl-File-Spec
	virtual/perl-Sys-Syslog
	dev-perl/Net-DNS
	dev-perl/Net-IP
	>=mail-mta/postfix-2.1"

pkg_setup() {
	enewgroup 'polw'
	enewuser 'polw' -1 -1 -1 'polw'
}

src_prepare() {
	eapply "${WORKDIR}"/patches/*.patch

	default
}

src_compile() { :; }

src_install() {
	exeinto /usr/libexec/postfix
	doexe policyd-weight
	fowners root:wheel /usr/libexec/postfix/policyd-weight

	doman man/man5/*.5 man/man8/*.8
	dodoc *.txt

	insinto /etc
	newins policyd-weight.conf.sample policyd-weight.conf

	newinitd "${FILESDIR}/${PN}.init.d-r2" "${PN}"

	newtmpfiles "${FILESDIR}"/${PN}.tmpfile ${PN}.conf
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
}
