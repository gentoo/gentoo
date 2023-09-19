# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Program to interactively take a 'snapshot' of a region of the screen"
HOMEPAGE="ftp://ftp.ac-grenoble.fr/ge/Xutils/"
SRC_URI="ftp://ftp.ac-grenoble.fr/ge/Xutils/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux"

COMMON_DEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	sys-libs/zlib:=
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXpm"
RDEPEND="
	${COMMON_DEPEND}
	media-fonts/font-misc-misc"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	dev-lang/perl
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${FILESDIR}"/${P}-root_name.patch
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	sed -i \
		-e 's|/usr/share/locale|$(LOCALEDIR)|g' \
		-e 's|/usr/share/man/man1|$(MANDIR)|g' \
		-e '/cd po.*install/s|cd.*|$(MAKE) -C po LOCALEDIR=$(LOCALEDIR) install|' \
		-e '21s|.*|LOCALEDIR = /usr/share/locale|' \
		Imakefile || die
	sed -i \
		-e '/^LOCALEDIR=/d' \
		po/Makefile || die
}

src_configure() {
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	default

	find "${ED}" -type f -name '*.1.gz' -exec gunzip {} + || die
}
