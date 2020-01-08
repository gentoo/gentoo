# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Dockapp CPU monitor resembling Xosview, support for smp"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop/"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/wmmon+smp.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S="${WORKDIR}/wmmon.app/wmmon"

PATCHES=( "${FILESDIR}"/${P}-list.patch )

src_prepare() {
	tc-export CC
	# Respect LDFLAGS, see bug #335047
	sed \
		-e 's/cc -o/${CC} ${LDFLAGS} -o/' \
		-e 's/cc -c/${CC} ${CFLAGS} -c/' \
		-i Makefile || die

	cd "${WORKDIR}"/wmmon.app || die
	default
}

src_install () {
	newbin wmmon wmmon+smp
	dodoc ../README
}
