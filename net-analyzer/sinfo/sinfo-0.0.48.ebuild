# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sinfo/sinfo-0.0.48.ebuild,v 1.1 2014/12/18 10:19:26 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="A monitoring tool for networked computers"
HOMEPAGE="http://www.ant.uni-bremen.de/whomes/rinas/sinfo/"
SRC_URI="${HOMEPAGE}download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 static-libs"

RDEPEND="
	!sys-cluster/slurm
	dev-libs/boost
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	cp "${FILESDIR}"/${P}-acinclude.m4 acinclude.m4 || die
	epatch "${FILESDIR}"/${PN}-0.0.47-tinfo.patch
	eautoreconf
}

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	econf $(use_enable ipv6 IPv6)
}

src_install() {
	default

	newconfd "${FILESDIR}"/sinfod.confd sinfod
	newinitd "${FILESDIR}"/sinfod.initd sinfod
}
