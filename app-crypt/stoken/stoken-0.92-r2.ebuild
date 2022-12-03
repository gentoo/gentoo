# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Software Token for Linux/UNIX"
HOMEPAGE="https://github.com/cernekee/stoken"
SRC_URI="https://github.com/cernekee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"
IUSE="gtk static-libs"

# TODO: add a USE flag to enable optional use of tomcrypt instead of nettle.
RDEPEND="
	dev-libs/nettle
	gtk? ( >=x11-libs/gtk+-3.12:3 )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_with gtk)
		$(use_enable static-libs static)
		--with-nettle
		--without-tomcrypt
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -type f -delete || die
}
