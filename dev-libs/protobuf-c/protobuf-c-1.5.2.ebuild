# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check 'next' branch for backports.

inherit autotools multilib-minimal

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Protocol Buffers implementation in C"
HOMEPAGE="https://github.com/protobuf-c/protobuf-c"
SRC_URI="
	https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
# Subslot == SONAME version
SLOT="0/1.0.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="static-libs"

BDEPEND="
	dev-build/autoconf-archive
	>=dev-libs/protobuf-3:0
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/protobuf-3:0=[${MULTILIB_USEDEP}]"
# NOTE
# protobuf links to abseil-cpp libraries via it's .pc files.
# To cause rebuild when the abseil-cpp version changes we add it to RDEPEND only.
RDEPEND="${DEPEND}
	dev-cpp/abseil-cpp:=[${MULTILIB_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-PR797.patch"
)

src_prepare() {
	default

	# old bundled version
	rm m4/ax_cxx_compile_stdcxx.m4 || die

	if has_version ">=dev-cpp/abseil-cpp-20260107.0"; then
		# needs >=c++20
		sed -e "/AX_CXX_COMPILE_STDCXX/{s/17/20/}" -i configure.ac || die
	fi

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
