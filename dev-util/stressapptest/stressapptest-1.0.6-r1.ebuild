# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils autotools

MY_P="${P}_autoconf"
DESCRIPTION="Stressful Application Test"
HOMEPAGE="https://code.google.com/p/stressapptest/"
SRC_URI="https://stressapptest.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE="debug"

RDEPEND="dev-libs/libaio"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	epatch "${FILESDIR}"/${P}-pthread-test.patch
	epatch "${FILESDIR}"/${P}-misc-fixes.patch
	eautoreconf
}

src_configure() {
	econf --disable-default-optimizations
}
