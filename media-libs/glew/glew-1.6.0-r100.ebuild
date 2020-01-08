# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib-minimal toolchain-funcs versionator

DESCRIPTION="The OpenGL Extension Wrangler Library"
HOMEPAGE="http://glew.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]"

DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libX11"

DOCS=""

src_prepare() {
	default

	sed -i \
		-e '/$(CC) $(CFLAGS) -o/s:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' \
		-e '/glew.lib:/s|lib/$(LIB.STATIC) ||' \
		-e '/glew.lib.mx:/s|lib/$(LIB.STATIC.MX) ||' \
		Makefile || die

	# don't do stupid Solaris specific stuff that won't work in Prefix
	cp config/Makefile.linux config/Makefile.solaris || die
	# and let freebsd be built as on linux too
	cp config/Makefile.linux config/Makefile.freebsd || die

	multilib_copy_sources
}

glew_system() {
	# Set the SYSTEM variable instead of probing. #523444 #595280
	case ${CHOST} in
	*linux*)          echo "linux" ;;
	*-freebsd*)       echo "freebsd" ;;
	*-darwin*)        echo "darwin" ;;
	*-solaris*)       echo "solaris" ;;
	mingw*|*-mingw*)  echo "mingw" ;;
	*) die "Unknown system ${CHOST}" ;;
	esac
}

set_opts() {
	myglewopts=(
		AR="$(tc-getAR)"
		STRIP=true
		CC="$(tc-getCC)"
		LD="$(tc-getCC) ${LDFLAGS}"
		SYSTEM="$(glew_system)"
		M_ARCH=""
		LDFLAGS.EXTRA=""
		LDFLAGS.GL="-lGL" # Don't need X libs!
		POPT="${CFLAGS}"
	)
}

multilib_src_compile() {
	set_opts
	emake glew.lib{,.mx} "${myglewopts[@]}"
}

multilib_src_install() {
	newlib.so lib/libGLEW.so.${SLOT}.* libGLEW.so.${SLOT}
	newlib.so lib/libGLEWmx.so.${SLOT}.* libGLEWmx.so.${SLOT}
}
