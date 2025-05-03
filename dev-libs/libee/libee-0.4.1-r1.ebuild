# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An Event Expression Library inspired by CEE"
HOMEPAGE="http://www.libee.org"
SRC_URI="http://www.libee.org/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa x86 ~amd64-linux"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2:=
	dev-libs/libestr
"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-static \
		$(use_enable test testbench) \
		$(use_enable debug)
}

src_compile() {
	emake -j1
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
