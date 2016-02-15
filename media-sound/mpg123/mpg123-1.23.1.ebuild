# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit flag-o-matic toolchain-funcs libtool multilib-minimal

DESCRIPTION="a realtime MPEG 1.0/2.0/2.5 audio player for layers 1, 2 and 3"
HOMEPAGE="http://www.mpg123.org/"
SRC_URI="http://www.mpg123.org/download/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="cpu_flags_x86_3dnow cpu_flags_x86_3dnowext alsa altivec coreaudio int-quality ipv6 jack cpu_flags_x86_mmx nas oss portaudio pulseaudio sdl cpu_flags_x86_sse"

# No MULTILIB_USEDEP here since we only build libmpg123 for non native ABIs.
RDEPEND="app-eselect/eselect-mpg123
	|| ( dev-libs/libltdl:0 <sys-devel/libtool-2.4.3-r2:2 )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	nas? ( media-libs/nas )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-soundlibs-20130224-r9
		!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	sys-devel/libtool
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS NEWS.libmpg123 README )

pkg_setup() {
	# Build fails without -D_GNU_SOURCE like this:
	# error: ‘struct hostent’ has no member named ‘h_addr’
	append-cflags -D_GNU_SOURCE
}

src_prepare() {
	default
	elibtoolize # for Darwin bundles
}

multilib_src_configure() {
	local _audio=dummy
	local _output=dummy
	local _cpu=generic_fpu

	if $(multilib_is_native_abi) ; then
		for flag in nas portaudio sdl oss jack alsa pulseaudio coreaudio; do
			if use ${flag}; then
				_audio+=" ${flag/pulseaudio/pulse}"
				_output=${flag/pulseaudio/pulse}
			fi
		done
	fi

	use altivec && _cpu=altivec

	if [[ $(tc-arch) == amd64 || ${ARCH} == x64-* ]]; then
		use cpu_flags_x86_sse && _cpu=x86-64
	elif use x86 && gcc-specs-pie ; then
		# Don't use any mmx, 3dnow, sse and 3dnowext #bug 164504
		_cpu=generic_fpu
	elif use x86-macos ; then
		# ASM doesn't work quite as expected with the Darwin linker
		_cpu=generic_fpu
	else
		use cpu_flags_x86_mmx && _cpu=mmx
		use cpu_flags_x86_3dnow && _cpu=3dnow
		use cpu_flags_x86_sse && _cpu=x86
		use cpu_flags_x86_3dnowext && _cpu=x86
	fi

	local myconf=""
	multilib_is_native_abi || myconf="${myconf} --disable-modules"

	ECONF_SOURCE="${S}" econf \
		--with-optimization=0 \
		--with-audio="${_audio}" \
		--with-default-audio=${_output} \
		--with-cpu=${_cpu} \
		--enable-network \
		$(use_enable ipv6) \
		--enable-int-quality=$(usex int-quality) \
		${myconf}

	if ! $(multilib_is_native_abi) ; then
		sed -i -e 's:src doc:src/libmpg123:' Makefile || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	mv "${ED}"/usr/bin/mpg123{,-mpg123}
	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
}

pkg_postinst() {
	eselect mpg123 update ifunset
}

pkg_postrm() {
	eselect mpg123 update ifunset
}
