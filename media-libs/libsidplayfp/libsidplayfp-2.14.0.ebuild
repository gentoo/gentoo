# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library for the sidplay2 fork with resid-fp"
HOMEPAGE="https://github.com/libsidplayfp/libsidplayfp"
SRC_URI="https://github.com/libsidplayfp/libsidplayfp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="~amd64 ~hppa ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libgcrypt:="
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-libs/unittest++ )"

src_prepare() {
	default

	# fix automagic. warning: modifying .ac triggers maintainer mode.
	sed -i -e 's:doxygen:dIsAbLe&:' configure || die
}

src_configure() {
	local myeconfargs=(
		# Avoid automagic media-libs/resid dep, can wire up if requested
		--without-exsid
		$(use_enable test tests)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
