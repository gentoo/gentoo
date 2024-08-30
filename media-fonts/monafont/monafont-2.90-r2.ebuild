# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_/}"
inherit font

DESCRIPTION="Japanese bitmap and TrueType fonts suitable for browsing 2ch"
HOMEPAGE="https://monafont.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/${PN}/${MY_P}.tar.bz2
	truetype? ( https://downloads.sourceforge.net/${PN}/${PN}-ttf-${PV}.zip )"
S="${WORKDIR}/${MY_P}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="truetype"
# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="
	app-arch/unzip
	dev-lang/perl
	x11-apps/bdftopcf
	x11-apps/mkfontscale
"

FONT_S="${WORKDIR}"
FONT_SUFFIX="ttf"
FONTDIR="/usr/share/fonts/${PN}"

src_prepare() {
	default
	sed -i -e 's:$(X11BINDIR)/mkdirhier:/bin/mkdir -p:' Makefile || die
}

src_compile() {
	export PERL_BADLANG=0
	export LC_CTYPE=C
	emake X11BINDIR="${EPREFIX}/usr/bin"
}

src_install() {
	emake install X11BINDIR="${EPREFIX}/usr/bin" X11FONTDIR="${ED}${FONTDIR}"

	mkfontdir "${ED}${FONTDIR}"
	insinto "${FONTDIR}"
	newins fonts.alias.mona fonts.alias

	dodoc README.{ascii,euc}

	if use truetype; then
		local DOCS=( "${WORKDIR}"/README-ttf.txt )
		font_src_install
	fi
}

pkg_postinst() {
	font_pkg_postinst
	elog
	elog "You need to add following line into 'Section \"Files\"' in"
	elog "XF86Config and reboot X Window System, to use these fonts."
	elog
	elog "\tFontPath \"${EROOT}${FONTDIR}\""
	elog
}
