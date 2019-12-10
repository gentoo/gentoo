# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="debug libressl ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/libsigc++-2.2.2:2
	ssl? (
	    !libressl? ( dev-libs/openssl:0= )
	    libressl? ( dev-libs/libressl:= )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/cppunit"

PATCHES=(
	"${FILESDIR}/${PN}-0001-Fix-the-DH-parameters-generation-with-OpenSSL-1.1.patch"
	"${FILESDIR}/${PN}-openssl-1.1-part2.patch"
	"${FILESDIR}/${PN}-openssl-1.1-part3.patch"
	"${FILESDIR}/${PN}-0.13.7-kqueue-configure.patch"
	"${FILESDIR}/${PN}-0.13.7-execinfo-configure.patch"
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
		disable_instrumentation="--disable-instrumentation"
	fi

	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ssl openssl) \
		${disable_instrumentation} \
		--with-posix-fallocate \
		--with-zlib="${EROOT%/}/usr/"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete
}
