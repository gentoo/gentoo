# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs

DESCRIPTION="multishape 3d rotating dots"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/116"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/153/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-stringh.patch
	sed -e "s:cc:$(tc-getCC):g" \
		-e "s:-g -O2:${CFLAGS}:g" -i Makefile

	#Fix compilation target
	sed -e "s:wmifs:wmdots:" -i Makefile

	#Honour Gentoo LDFLAGS, see bug #336982
	sed -e "s:-o wmdots:\$(LDFLAGS) -o wmdots:" -i Makefile
}

src_compile() {
	emake clean || die "emake clean failed."
	emake LIBDIR="-L/usr/$(get_libdir)" || die "emake failed."
}

src_install() {
	dobin wmdots
}
