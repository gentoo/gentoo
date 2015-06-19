# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/flow-tools/flow-tools-0.68.5.1-r4.ebuild,v 1.3 2014/12/28 16:03:48 titanofold Exp $

EAPI=5
inherit eutils user

DESCRIPTION="library and programs to collect, send, process, and generate reports from NetFlow data"
HOMEPAGE="http://code.google.com/p/flow-tools/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug mysql postgres ssl static-libs"

RDEPEND="sys-apps/tcp-wrappers
	sys-libs/zlib
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	ssl? ( dev-libs/openssl )"

DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

DOCS=( ChangeLog README SECURITY TODO )

pkg_setup() {
	enewgroup flows
	enewuser flows -1 -1 /var/lib/flows flows
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-run.patch
	epatch "${FILESDIR}"/${P}-syslog.patch
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(usex mysql --with-mysql '') \
		$(usex postgres --with-postgresql=yes --with-postgresql=no) \
		$(usex ssl --with-openssl '') \
		--sysconfdir=/etc/flow-tools
}

src_install() {
	default

	prune_libtool_files

	exeinto /var/lib/flows/bin
	doexe "${FILESDIR}"/linkme

	keepdir /var/lib/flows/ft

	newinitd "${FILESDIR}/flowcapture.initd" flowcapture
	newconfd "${FILESDIR}/flowcapture.confd" flowcapture

	fowners flows:flows /var/lib/flows
	fowners flows:flows /var/lib/flows/bin
	fowners flows:flows /var/lib/flows/ft

	fperms 0755 /var/lib/flows
	fperms 0755 /var/lib/flows/bin
}

pkg_preinst() {
	enewgroup flows
	enewuser flows -1 -1 /var/lib/flows flows
}
