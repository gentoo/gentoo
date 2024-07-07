# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Protocol Buffers implementation in C"
HOMEPAGE="https://github.com/protobuf-c/protobuf-c"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
# Subslot == SONAME version
SLOT="0/1.0.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="static-libs"

BDEPEND="
	>=dev-libs/protobuf-3:0
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/protobuf-3:0=[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-Clean-CMake.patch"
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--enable-year2038
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -type f -delete || die
	einstalldocs
}
