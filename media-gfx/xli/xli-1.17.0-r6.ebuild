# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

SNAPSHOT="2005-02-27"
DESCRIPTION="X Load Image: view images or load them to root window"
HOMEPAGE="ftp://ftp.ibiblio.org/pub/Linux/apps/graphics/viewers/X/xli-1.16.README"
SRC_URI="http://pantransit.reptiles.org/prog/xli/xli-${SNAPSHOT}.tar.gz"
S="${WORKDIR}/${PN}-${SNAPSHOT}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	app-arch/bzip2:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	sys-libs/zlib:=
	x11-libs/libX11
	x11-libs/libXext
	!media-gfx/xloadimage"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${FILESDIR}"/xli-security-gentoo.diff
	"${FILESDIR}"/${P}-fix-scale-zoom.patch #282979
	"${FILESDIR}"/${P}-libpng14.patch
	"${FILESDIR}"/${P}-clang16.patch
)

DOCS=( README README.xloadimage ABOUTGAMMA TODO chkgamma.jpg )

src_prepare() {
	default

	# avoid conflicts on systems that have zopen in system headers
	sed -i -e "s:zopen:xli_zopen:g" *

	sed -i Imakefile \
		-e '/^DEFINES =/s/$/ -DHAVE_GUNZIP -DHAVE_BUNZIP2 /' \
		-e '/CCOPTIONS =/s/=.*/=/'

	# This is a hack to avoid a parse error on /usr/include/string.h
	# when _BSD_SOURCE is defined. This may be a bug in that header.
	sed	-i png.c \
		-e '/^#include "xli.h"/i#undef _BSD_SOURCE'

	# This hack will allow xli to compile using gcc-3.3
	sed -i rlelib.c \
		-e 's/#include <varargs.h>//'
}

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CDEBUGFLAGS="${CFLAGS}"
		EXTRA_LDOPTIONS="${LDFLAGS}"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	dobin xli xlito

	dosym xli /usr/bin/xsetbg
	dosym xli /usr/bin/xview

	newman xli.man xli.1
	newman xliguide.man xliguide.1
	newman xlito.man xlito.1
	einstalldocs

	insinto /etc/X11/app-defaults
	newins "${FILESDIR}"/Xli.ad Xli
	fperms a+r /etc/X11/app-defaults/Xli
}
