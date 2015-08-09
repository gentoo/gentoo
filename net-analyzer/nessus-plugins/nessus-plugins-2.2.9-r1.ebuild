# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A remote security scanner for Linux (nessus-plugins)"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/nessus-plugins-GPL-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-libs/openssl:0
	~net-analyzer/nessus-core-${PV}
	~net-analyzer/nessus-libraries-${PV}
	net-libs/libpcap"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}

src_prepare() {
	tc-export CC
	epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_install() {
	default
	dodoc docs/*.txt
}
