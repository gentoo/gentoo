# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtz/wmtz-0.7.ebuild,v 1.22 2014/08/10 20:09:33 slyfox Exp $

EAPI=3

inherit eutils multilib toolchain-funcs

DESCRIPTION="dockapp that shows the time in multiple timezones"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch

	#Honour Gentoo LDFLAGS, see bug #337890.
	sed -e "s/\$(FLAGS) -o wmtz/\$(LDFLAGS) -o wmtz/" -i Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" FLAGS="${CFLAGS}" \
		LIBDIR="-L/usr/$(get_libdir)" || die "emake failed."
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	insinto /etc
	doins wmtzrc
	dodoc ../{BUGS,CHANGES,README}
}
