# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Dockapp mixer for OSS or ALSA"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmix"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

S=${WORKDIR}/dockapps

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	doman "${FILESDIR}"/${PN}.1
	dodoc AUTHORS BUGS NEWS README sample.wmixrc
}
