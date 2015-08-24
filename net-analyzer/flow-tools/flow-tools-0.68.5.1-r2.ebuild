# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils user

DESCRIPTION="library and programs to collect, send, process, and generate reports from NetFlow data"
HOMEPAGE="https://code.google.com/p/flow-tools/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
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
	sed -i \
		-e 's|/var/run/|/run/|g' \
		src/flow-capture.c \
		src/flow-fanout.c \
		|| die
}

src_configure() {
	local myconf="--sysconfdir=/etc/flow-tools"
	use mysql && myconf="${myconf} --with-mysql"
	if use postgres; then
		myconf="${myconf} --with-postgresql=yes"
	else
		myconf="${myconf} --with-postgresql=no"
	fi
	use ssl && myconf="${myconf} --with-openssl"
	econf ${myconf} $(use_enable static-libs static)
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
