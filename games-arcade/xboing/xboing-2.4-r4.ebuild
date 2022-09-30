# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Blockout type game where you bounce a ball trying to destroy blocks"
HOMEPAGE="http://www.techrescue.org/xboing/"
SRC_URI="http://www.techrescue.org/xboing/${PN}${PV}.tar.gz
	mirror://gentoo/${P}-debian.patch.bz2"
S="${WORKDIR}/${PN}"

LICENSE="xboing"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	x11-libs/libX11
	x11-libs/libXpm"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${WORKDIR}"/${P}-debian.patch
	"${FILESDIR}"/${P}-buffer.patch
	"${FILESDIR}"/${P}-sleep.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default
	sed -i '/^#include/s:xpm\.h:X11/xpm.h:' *.c || die
	sed -i "s:GENTOO_VER:${PF/${PN}-/}:" Imakefile || die
}

src_configure() {
	append-cflags -fcommon #707214

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf -a || die
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CDEBUGFLAGS="${CFLAGS}"
		LOCAL_LDFLAGS="${LDFLAGS}"
		HIGH_SCORE_DIR="${EPREFIX}/var/games"
		XBOING_DIR="${EPREFIX}/usr/share/${PN}"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		LOCAL_LDFLAGS="${LDFLAGS}"
		PREFIX="${D}"
		BINDIR="${ED}/usr/bin"
		HIGH_SCORE_DIR="${EPREFIX}/var/games"
		XBOING_DIR="${EPREFIX}/usr/share/${PN}"
	)
	emake "${myemakeargs[@]}" install

	newman xboing.man xboing.6
	dodoc README docs/*.doc

	fowners root:gamestat /var/games/xboing.score /usr/bin/xboing
	fperms 660 /var/games/xboing.score
	fperms 2755 /usr/bin/xboing
}
