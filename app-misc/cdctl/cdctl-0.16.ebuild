# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Utility to control your cd/dvd drive"
HOMEPAGE="http://cdctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdctl/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

PATCHES=( "${FILESDIR}"/${PN}-0.16-Makefile.in.patch )

src_prepare() {
	default
	eautoreconf
}
