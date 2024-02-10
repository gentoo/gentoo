# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Display misc information about your hardware"
HOMEPAGE="http://syscriptor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.15-dont-inject-additional-flags.patch
	"${FILESDIR}"/${PN}-1.5.15-respect-CC-environment-variable.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}
