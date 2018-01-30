# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user

DESCRIPTION="Log parsing and notification program"
HOMEPAGE="http://dev.inversepath.com/trac/tenshi"
SRC_URI="https://github.com/inversepath/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/IO-BufferedSelect
	sys-apps/coreutils"

pkg_setup() {
	enewgroup tenshi
	enewuser tenshi -1 -1 /var/lib/tenshi tenshi
}

src_prepare() {
	default
	# Fix for bug #241254
	sed -i 's:^docdir =.*:docdir = /usr/share/doc/${PF}:' \
		Makefile || die "docdir substitution failed"
}

src_install() {
	emake DESTDIR="${D}" install
	doman tenshi.8
	newinitd tenshi.openrc-init tenshi

	# We don't need to install LICENSE files.
	rm "${D}/usr/share/doc/${PF}/LICENSE" || die 'failed to remove LICENSE'
}

pkg_postinst() {
	ewarn "The sample config installed to ${ROOT}etc/tenshi/tenshi.conf"
	ewarn "monitors /var/log/messages which, by default, can not be read"
	ewarn "by the tenshi user.  Make sure that the tenshi user has read"
	ewarn "permission on all the files that you want tenshi to monitor."
}
