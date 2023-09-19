# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Log parsing and notification program"
HOMEPAGE="https://inversepath.com/tenshi.html https://github.com/f-secure-foundry/tenshi"
SRC_URI="https://github.com/f-secure-foundry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	acct-group/tenshi
	acct-user/tenshi
	dev-lang/perl
	dev-perl/IO-BufferedSelect
	sys-apps/coreutils
"

src_prepare() {
	default

	# Fix for bug #241254
	sed 's:^docdir =.*:docdir = /usr/share/doc/${PF}:' -i Makefile || die "docdir substitution failed"
}

src_install() {
	default

	doman tenshi.8
	keepdir /var/lib/tenshi
	newinitd tenshi.openrc-init tenshi
}

pkg_postinst() {
	ewarn "The sample config installed to ${ROOT}/etc/tenshi/tenshi.conf"
	ewarn "monitors /var/log/messages which, by default, can not be read"
	ewarn "by the tenshi user.  Make sure that the tenshi user has read"
	ewarn "permission on all the files that you want tenshi to monitor."
}
