# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Dockapp CPU monitor resembling Xosview, support for smp"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/wmmon+smp.tar.gz"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/wmmon.app/wmmon

src_prepare() {
	# Respect LDFLAGS, see bug #335047
	sed \
		-e 's/cc -o/${CC} ${LDFLAGS} -o/' \
		-e 's/cc -c/${CC} ${CFLAGS} -c/' \
		-i Makefile || die
	tc-export CC

	cd "${WORKDIR}"/wmmon.app || die
	ls
	epatch "${FILESDIR}"/${P}-list.patch
}

src_install () {
	newbin wmmon wmmon+smp
	dodoc ../README
}
