# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="mpg123"
MY_P="${MY_PN}-${PV}"
inherit autotools flag-o-matic toolchain-funcs multilib-minimal

DESCRIPTION="Libraries for realtime MPEG 1.0/2.0/2.5 audio player for layers 1, 2 and 3"
HOMEPAGE="https://www.mpg123.org/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="int-quality cpu_flags_x86_3dnow cpu_flags_x86_3dnowext cpu_flags_ppc_altivec cpu_flags_x86_mmx cpu_flags_x86_sse"

# No MULTILIB_USEDEP here since we only build libmpg123 for non native ABIs.
# Note: build system prefers libsdl2 > libsdl. We could in theory add both
# but it's tricky when it comes to handling switching between them properly.
# We'd need a USE flag for both sdl1 and sdl2 and to make them clash.
RDEPEND="
	dev-libs/libltdl:0
	!<media-sound/mpg123-1.32.3-r1
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS NEWS.libmpg123 README )

PATCHES=(
	"${FILESDIR}"/mpg123-1.32.3-build-programs-component.patch
	"${FILESDIR}"/mpg123-1.32.3-build-with-installed-libs.patch
)

src_prepare() {
	default

	# Rerun autotools with patched configure.ac
	eautoreconf
}

multilib_src_configure() {
	local _audio=dummy
	local _output=dummy
	local _cpu=generic_fpu

	# Build fails without -D_GNU_SOURCE like this:
	# error: ‘struct hostent’ has no member named ‘h_addr’
	append-cflags -D_GNU_SOURCE

	append-lfs-flags

	use cpu_flags_ppc_altivec && _cpu=altivec

	if [[ $(tc-arch) == amd64 || ${ARCH} == x64-* ]]; then
		use cpu_flags_x86_sse && _cpu=x86-64
	elif use x86 && gcc-specs-pie ; then
		# Don't use any mmx, 3dnow, sse and 3dnowext
		# bug #164504
		_cpu=generic_fpu
	else
		use cpu_flags_x86_mmx && _cpu=mmx
		use cpu_flags_x86_3dnow && _cpu=3dnow
		use cpu_flags_x86_sse && _cpu=x86
		use cpu_flags_x86_3dnowext && _cpu=x86
	fi

	local myconf=(
		--with-optimization=0
		--with-cpu=${_cpu}
		--enable-int-quality=$(usex int-quality)
		--disable-components --enable-libmpg123 --enable-libsyn123 --enable-libout123
	)

	multilib_is_native_abi || myconf+=( --disable-modules )

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	if ! $(multilib_is_native_abi) ; then
		sed -i -e 's:src doc:src/libmpg123:' Makefile || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
