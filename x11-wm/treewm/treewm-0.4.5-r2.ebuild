# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="WindowManager that arranges the windows in a tree (not in a list)"
HOMEPAGE="http://treewm.sourceforge.net/"
SRC_URI="mirror://sourceforge/treewm/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc sparc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86vm
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/imake"

src_prepare() {
	default
	# bug 251845
	eapply "${FILESDIR}/${P}-gcc43.patch"
	# bug 86453
	sed -i xprop/dsimple.c \
		-e 's:malloc:Malloc:g' \
		|| die "sed xprop/dsimple.c"
}

src_compile() {
	# only compile treewm, not (x11-apps/){xprop,xkill}
	emake treewm \
		CXX=$(tc-getCXX) \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		PREFIX="/usr" ROOT="${D}"
}

src_install() {
	# only install treewm, not (x11-apps/){xprop,xkill}
	dobin src/treewm
	dodoc AUTHORS ChangeLog PROBLEMS README README.tiling TODO default.cfg \
		sample.cfg
	insinto /usr/share/pixmaps/treewm
	doins src/pixmaps/*.xpm
}

pkg_postinst() {
	elog "x11-wm/treewm used to install its own versions of x11-apps/xprop and"
	elog "x11-apps/xkill as treewm-xprop and treewm-xkill respectively, since"
	elog "they are assumed to be broken in combination with treewm. Since"
	elog "X(org) has become modular since treewm's last release and are not"
	elog "installed by default, we can leave those out and simply point out"
	elog "that it is NOT adviseable to use these programs when using treewm."
}
