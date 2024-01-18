# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
SRC_URI="http://rtorrent.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
# The README says that the library ABI is not yet stable and dependencies on
# the library should be an explicit, syncronized version until the library
# has had more time to mature. Until it matures we should not include a soname
# subslot.
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug ssl"

# cppunit dependency - https://github.com/rakshasa/libtorrent/issues/182
RDEPEND="
	dev-util/cppunit:=
	sys-libs/zlib
	ssl? ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13.8-sysroot.patch
	"${FILESDIR}"/${PN}-0.13.8-configure-clang-16.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 518582
	local disable_instrumentation
	echo -e "#include <inttypes.h>\nint main(){ int64_t var = 7; __sync_add_and_fetch(&var, 1); return 0;}" > "${T}/sync_add_and_fetch.c" || die
	$(tc-getCC) ${CFLAGS} -o /dev/null -x c "${T}/sync_add_and_fetch.c" >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		einfo "Disabling instrumentation"
		disable_instrumentation="--disable-instrumentation"
	fi

	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ssl openssl) \
		${disable_instrumentation} \
		--with-posix-fallocate
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
