# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="TWM descendant that implements a Virtual Desktop"
HOMEPAGE="http://www.vtwm.org/"
SRC_URI="http://www.vtwm.org/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc sparc x86"
IUSE="rplay"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm
	rplay? ( media-sound/rplay )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	sys-devel/bison
	sys-devel/flex
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

src_prepare() {
	eapply "${FILESDIR}"/${P}-do-not-rm.patch
	sed -i Imakefile \
		-e 's:-L/usr/local/lib::g' \
		-e 's:-I/usr/local/include::g' \
		|| die "sed Imakefile"
	if ! use rplay ; then
		sed -i Imakefile \
			-e 's:^XCOMM\ \(.*NO_SOUND\):\1:' \
			-e 's:^\(SOUNDLIB.*\):XCOMM\ \1:' \
			-e 's:sound\..::g' \
			|| die "sed Imakefile"
		eapply "${FILESDIR}"/${P}-NO_SOUND_SUPPORT.patch
	fi
	default
}

src_configure() {
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
	emake BINDIR=/usr/bin \
		LIBDIR=/etc/X11 \
		MANPATH=/usr/share/man \
		DESTDIR="${D}" install

	echo "#!/bin/sh" > vtwm
	echo "xsetroot -cursor_name left_ptr &" >> vtwm
	echo "/usr/bin/vtwm" >> vtwm
	exeinto /etc/X11/Sessions
	doexe vtwm
	dodoc doc/{4.7.*,CHANGELOG,BUGS,DEVELOPERS,HISTORY,SOUND,WISHLIST}
}
