# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmon+smp/wmmon+smp-1.0-r2.ebuild,v 1.4 2015/03/31 07:56:53 ago Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Dockapp CPU monitor resembling Xosview, support for smp"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/wmmon+smp.tar.gz"
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
	x11-proto/xextproto"

S=${WORKDIR}/wmmon.app/wmmon

src_prepare() {
	# Respect LDFLAGS, see bug #335047
	sed \
		-e 's/cc -o/${CC} ${LDFLAGS} -o/' \
		-e 's/cc -c/${CC} ${CFLAGS} -c/' \
		-i Makefile || die
	tc-export CC
}

src_install () {
	newbin wmmon wmmon+smp
	dodoc ../README
}
