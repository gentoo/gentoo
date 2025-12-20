# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="${PN}-fonts"

inherit font gnome.org meson

DESCRIPTION="Default fontset for GNOME Shell"
HOMEPAGE="https://wiki.gnome.org/Projects/CantarellFonts"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE=""

BDEPEND="
	>=sys-devel/gettext-0.20
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# Font eclass settings
FONT_S="${S}/prebuilt"
FONT_SUFFIX="otf"

src_prepare() {
	# Leave prebuilt font installation to font.eclass
	sed -e "/subdir('prebuilt')/d" -i meson.build || die

	default
}

src_configure() {
	local emesonargs=(
		-Dfontsdir=${FONTDIR}
		-Duseprebuilt=true
		-Dbuildappstream=true
		-Dbuildstatics=false
		-Dbuildvf=true
	)
	meson_src_configure
}

src_install() {
	font_src_install
	local DOCS=( NEWS README.md )
	meson_src_install
}
