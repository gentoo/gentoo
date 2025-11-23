# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit tmpfiles

PATCH_VER="1.0"

DESCRIPTION="Weighted Policy daemon for Postfix"
HOMEPAGE="http://www.policyd-weight.org/"
SRC_URI="
	http://www.policyd-weight.org/releases/${P}.tar.gz
	mirror://gentoo/b9/${P}-patches-${PATCH_VER}.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 x86"

RDEPEND="
	acct-group/polw
	acct-user/polw
	dev-perl/Net-DNS
	dev-perl/Net-IP
	mail-mta/postfix
	virtual/perl-File-Spec
	virtual/perl-Sys-Syslog
"

src_prepare() {
	default
	eapply "${WORKDIR}"/patches/*.patch
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

	newinitd "${FILESDIR}"/policyd-weight.init.d-r2 policyd-weight

	newtmpfiles "${FILESDIR}"/policyd-weight.tmpfile policyd-weight.conf
}

pkg_postinst() {
	tmpfiles_process policyd-weight.conf
}
