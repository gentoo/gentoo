# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib toolchain-funcs

MY_P=${PN}${PV/_p/pl}
DESCRIPTION="Windowmanager ala Amiga(R) Workbench(R)"
HOMEPAGE="http://www.lysator.liu.se/~marcus/amiwm.html"
SRC_URI="ftp://ftp.lysator.liu.se/pub/X11/wm/${PN}/${MY_P}.tar.gz"

LICENSE="amiwm"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXext"

RDEPEND="${COMMON_DEPEND}
	media-gfx/xloadimage
	x11-apps/xrdb
	x11-apps/xsetroot
	x11-terms/xterm"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-gentoo.diff"
	"${FILESDIR}/${P}-implicts.patch"
	"${FILESDIR}/${P}-flex-2.6.3-fix.patch"
)

pkg_setup() {
	tc-export CC
}

src_prepare() {
	default
	sed -e "s:\$(exec_prefix)/lib:\$(exec_prefix)/$(get_libdir):" \
		-e '/^STRIPFLAG/s@-s@@' \
		-e '/$(LN_S)/s@$(DESTDIR)$(AMIWM_HOME)@../..$(AMIWM_HOME)@' \
		-i Makefile.in || die
	sed -i -e "s:/bin/ksh:/bin/sh:g" Xsession{,2}.in || die

	cat <<- EOF > "${T}"/amiwm
		#!/bin/sh
		exec /usr/bin/amiwm
	EOF
}

src_install() {
	local DOCS=( README* )
	default

	exeinto /etc/X11/Sessions
	doexe "${T}"/amiwm
}
