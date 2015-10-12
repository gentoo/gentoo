# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils eutils

DESCRIPTION="high performance network sniffer for packet inspection"
HOMEPAGE="http://netsniff-ng.org/"
SRC_URI="http://pub.${PN}.org/${PN}/${P}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libnl:1.1"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/src

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5.6-man-no-compress.patch
}

src_install() {
	cmake-utils_src_install
	dodoc ../{AUTHORS,README,REPORTING-BUGS}
}
