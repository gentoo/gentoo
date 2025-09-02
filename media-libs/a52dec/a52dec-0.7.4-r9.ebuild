# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Library for decoding ATSC A/52 streams used in DVD"
HOMEPAGE="https://liba52.sourceforge.net/"
SRC_URI="https://liba52.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="djbfft oss"

RDEPEND="djbfft? ( >=sci-libs/djbfft-0.76-r2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-freebsd.patch
	"${FILESDIR}"/${P}-tests-optional.patch
	"${FILESDIR}"/${P}-test-hidden-symbols.patch
	"${FILESDIR}"/${P}-dont-mangle-cflags.patch
)

src_prepare() {
	default

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die # bug #466978
	mv configure.{in,ac} || die

	eautoreconf

	filter-flags -fprefetch-loop-arrays
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--enable-shared \
		$(use_enable djbfft) \
		$(usev !oss --disable-oss)

	# remove useless subdirs
	if ! multilib_is_native_abi; then
		sed -i \
			-e 's/ src//' \
			-e 's/ libao//' \
			Makefile || die
	fi
}

multilib_src_compile() {
	emake CFLAGS="${CFLAGS}"
}

multilib_src_install_all() {
	einstalldocs
	dodoc HISTORY doc/liba52.txt

	find "${ED}" -name '*.la' -type f -delete || die
}
