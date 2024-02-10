# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Exchange data with Siemens phones"
HOMEPAGE="http://www.hendrik-sattler.de/scmxx/"
SRC_URI="mirror://sourceforge/scmxx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="bluetooth nls"

RDEPEND="bluetooth? ( net-wireless/bluez )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	default

	# Clang 16
	eautoreconf
}

src_install() {
	default

	exeinto /usr/lib/scmxx
	doexe contrib/*

	doman docs/*.1

	rm docs/README_WIN32.txt || die
	dodoc AUTHORS BUGS CHANGELOG README TODO docs/*.txt
}
