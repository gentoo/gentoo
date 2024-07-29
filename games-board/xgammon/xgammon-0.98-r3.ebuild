# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="very nice backgammon game for X"
HOMEPAGE="http://fawn.unibw-hamburg.de/steuer/xgammon/xgammon.html"
SRC_URI="http://fawn.unibw-hamburg.de/steuer/xgammon/Downloads/${P}a.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt
	!<x11-terms/kterm-6.2.0-r7"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

S="${WORKDIR}/${P}a"

PATCHES=(
	"${FILESDIR}"/${P}-broken.patch
	"${FILESDIR}"/${P}-r2-config.patch
	"${FILESDIR}"/${P}-glibc-2.32.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_compile() {
	env PATH=".:${PATH}" emake \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		CDEBUGFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	default
	# remove link to avoid collision (bug #668892)
	rm "${ED}"/usr/$(get_libdir)/X11/app-defaults || die
}

pkg_postinst() {
	einfo "xgammon need helvetica fonts"
	einfo "They can be loaded emerging media-fonts/font-adobe-100dpi"
	einfo "or similar. Remember to restart X after loading fonts"
}
