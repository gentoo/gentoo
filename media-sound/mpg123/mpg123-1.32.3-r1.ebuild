# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="a realtime MPEG 1.0/2.0/2.5 audio player for layers 1, 2 and 3"
HOMEPAGE="https://www.mpg123.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="alsa coreaudio int-quality ipv6 jack nas oss portaudio pulseaudio sdl"

# No MULTILIB_USEDEP here since we only build libmpg123 for non native ABIs.
# Note: build system prefers libsdl2 > libsdl. We could in theory add both
# but it's tricky when it comes to handling switching between them properly.
# We'd need a USE flag for both sdl1 and sdl2 and to make them clash.
RDEPEND="
	~media-libs/libmpg123-${PV}[${MULTILIB_USEDEP},int-quality?]
	dev-libs/libltdl:0
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	nas? ( media-libs/nas )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2 )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig
"
IDEPEND="app-eselect/eselect-mpg123"

DOCS=( AUTHORS ChangeLog NEWS NEWS.libmpg123 README )

PATCHES=(
	"${FILESDIR}"/mpg123-1.32.3-build-programs-component.patch
	"${FILESDIR}"/mpg123-1.32.3-build-with-installed-libs.patch
)

src_prepare() {
	default

	# Upstream already applied the change to move shared internal implementation headers
	# for next release, we just move them by hand now to fix build with patched sources.
	mv src/libmpg123/{abi_align.h,debug.h,sample.h,swap_bytes_impl.h,true.h} src/ || die

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

	if $(multilib_is_native_abi) ; then
		local flag
		for flag in nas portaudio sdl oss jack alsa pulseaudio coreaudio; do
			if use ${flag}; then
				_audio+=" ${flag/pulseaudio/pulse}"
				_output=${flag/pulseaudio/pulse}
			fi
		done
	fi

	local myconf=(
		--with-optimization=0
		--with-audio="${_audio}"
		--with-default-audio=${_output}
		--enable-network
		$(use_enable ipv6)
		--disable-components
	)

	multilib_is_native_abi || myconf+=( --disable-modules )
	multilib_is_native_abi && myconf+=( --enable-libout123-modules --enable-programs )

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	if ! $(multilib_is_native_abi) ; then
		sed -i -e 's:src doc:src/libmpg123:' Makefile || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	mv "${ED}"/usr/bin/mpg123{,-mpg123}
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	eselect mpg123 update ifunset
}

pkg_postrm() {
	eselect mpg123 update ifunset
}
