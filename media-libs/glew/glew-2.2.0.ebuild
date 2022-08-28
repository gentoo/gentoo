# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs

DESCRIPTION="The OpenGL Extension Wrangler Library"
HOMEPAGE="http://glew.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs"

DEPEND="
	>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXmu-1.1.1-r1[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-2.0.0-install-headers.patch
	)

	sed -i \
		-e '/INSTALL/s:-s::' \
		-e '/$(CC) $(CFLAGS) -o/s:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' \
		-e '/^.PHONY: .*\.pc$/d' \
		Makefile || die

	if ! use static-libs ; then
		sed -i \
			-e '/glew.lib:/s|lib/$(LIB.STATIC) ||' \
			-e '/glew.lib.mx:/s|lib/$(LIB.STATIC.MX) ||' \
			-e '/INSTALL.*LIB.STATIC/d' \
			Makefile || die
	fi

	# don't do stupid Solaris specific stuff that won't work in Prefix
	cp config/Makefile.linux config/Makefile.solaris || die
	# and let freebsd be built as on linux too
	cp config/Makefile.linux config/Makefile.freebsd || die

	default
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
		POPT="${CFLAGS}"
	)
}

multilib_src_compile() {
	set_opts
	emake \
		GLEW_PREFIX="${EPREFIX}/usr" \
		GLEW_DEST="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		"${myglewopts[@]}"
}

multilib_src_install() {
	set_opts
	emake \
		GLEW_DEST="${ED}/usr" \
		LIBDIR="${ED}/usr/$(get_libdir)" \
		PKGDIR="${ED}/usr/$(get_libdir)/pkgconfig" \
		"${myglewopts[@]}" \
		install.all

	dodoc README.md
	if use doc; then
		docinto html
		dodoc -r doc
	fi
}
