# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Utility to convert files in xfig format to OpenOffice.org Draw format"
LICENSE="GPL-2"
PVD=2

HOMEPAGE="https://sourceforge.net/projects/fig2sxd"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz
	 mirror://sourceforge/${PN}/${PN}_${PV}-${PVD}.diff.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${WORKDIR}"/${PN}_${PV}-${PVD}.diff
	epatch "${FILESDIR}"/${PN}-0.20-ldflags.patch
	epatch "${FILESDIR}"/${PN}-0.20-phony-check.patch
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" CXX="$(tc-getCXX)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc changelog
}
