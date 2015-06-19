# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtop/wmtop-0.9.0-r1.ebuild,v 1.6 2014/08/10 20:09:24 slyfox Exp $

EAPI=4
inherit eutils multilib toolchain-funcs

DESCRIPTION="dockapp for monitoring the top three processes using cpu or memory"
HOMEPAGE="http://www.swanson.ukfsn.org/#wmtop"
SRC_URI="http://www.swanson.ukfsn.org/wmdock/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_prepare() {
	sed -ie "s/\$(FLAGS) -o wmtop/\$(DEBUG) \$(LDFLAGS) -D\$(OS) -o wmtop/" Makefile || die "sed failed"
	epatch "${FILESDIR}"/${P}-meminfo.patch
}

src_compile() {
	emake CC="$(tc-getCC)" OPTS="${CFLAGS}" \
		LIBDIR="-L/usr/$(get_libdir)" \
		INCS="-I/usr/include/X11" linux
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc BUGS CHANGES README TODO
}
