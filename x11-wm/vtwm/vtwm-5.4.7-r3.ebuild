# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="TWM descendant that implements a Virtual Desktop"
HOMEPAGE="http://www.vtwm.org/"
SRC_URI="http://www.vtwm.org/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc sparc x86"

COMMON_DEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt"
RDEPEND="
	${COMMON_DEPEND}
	x11-apps/xsetroot"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	sys-devel/bison
	sys-devel/flex
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${FILESDIR}"/${P}-do-not-rm.patch
	"${FILESDIR}"/${P}-NO_SOUND_SUPPORT.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	# disable sound support, relies on last-rited media-sound/rplay
	sed -e 's:^XCOMM\ \(.*NO_SOUND\):\1:' \
		-e 's:^\(SOUNDLIB.*\):XCOMM\ \1:' \
		-e 's:sound\..::g' \
		-e 's:-I/usr/local/include::g' \
		-e 's:-L/usr/local/lib::g' \
		-i Imakefile || die
}

src_configure() {
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf -a || die "xmkmf failed"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	emake BINDIR="${EPREFIX}"/usr/bin \
		LIBDIR="${EPREFIX}"/etc/X11 \
		MANPATH="${EPREFIX}"/usr/share/man \
		DESTDIR="${D}" install

	exeinto /etc/X11/Sessions
	newexe - vtwm <<-EOF
		#!/usr/bin/env sh
		xsetroot -cursor_name left_ptr &
		"${EPREFIX}/usr/bin/vtwm"
	EOF

	dodoc doc/{4.7.*,CHANGELOG,BUGS,DEVELOPERS,HISTORY,SOUND,WISHLIST}
}
