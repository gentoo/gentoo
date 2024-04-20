# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit multilib-minimal toolchain-funcs

DESCRIPTION="The OpenGL Extension Wrangler Library"
HOMEPAGE="https://glew.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"

RDEPEND=">=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	!=media-libs/glew-1.10*:0"

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

	multilib_copy_sources
}

glew_system() {
	# Set the SYSTEM variable instead of probing. #523444 #595280
	case ${CHOST} in
	*linux*)          echo "linux" ;;
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
