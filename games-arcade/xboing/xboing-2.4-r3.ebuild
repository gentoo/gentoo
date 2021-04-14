# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Blockout type game where you bounce a ball trying to destroy blocks"
HOMEPAGE="http://www.techrescue.org/xboing/"
SRC_URI="http://www.techrescue.org/xboing/${PN}${PV}.tar.gz
	mirror://gentoo/xboing-${PV}-debian.patch.bz2"

LICENSE="xboing"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="acct-group/gamestat
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1
"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${WORKDIR}"/xboing-${PV}-debian.patch
	epatch "${FILESDIR}"/xboing-${PV}-buffer.patch
	epatch "${FILESDIR}"/xboing-${PV}-sleep.patch
	sed -i '/^#include/s:xpm\.h:X11/xpm.h:' *.c || die
	eapply_user
}

src_configure() {
	sed -i -e "s:GENTOO_VER:${PF/${PN}-/}:" Imakefile || die
	append-cflags -fcommon

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(tc-getCPP)}" xmkmf -a || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		XBOING_DIR="/usr/share/${PN}"
}

src_install() {
	emake \
		CC="$(tc-getCC)" \
		PREFIX="${D}" \
		BINDIR="${D}/usr/bin" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		XBOING_DIR="/usr/share/${PN}" \
		install
	newman xboing.man xboing.6
	dodoc README docs/*.doc

	fowners root:gamestat /var/games/xboing.score /usr/bin/xboing
	fperms 660 /var/games/xboing.score
	fperms 2755 /usr/bin/xboing
}
