# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="${PN}-fonts"

inherit font gnome.org meson

DESCRIPTION="Default fontset for GNOME Shell"
HOMEPAGE="https://wiki.gnome.org/Projects/CantarellFonts"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="media-libs/fontconfig"
# appstream-glib provided .loc and .its files required by gettext msgfmt for translation of .metainfo.xml
DEPEND="
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# Font eclass settings
FONT_CONF=("${S}/fontconfig/31-cantarell.conf")
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
	)
	meson_src_configure
}

src_install() {
	local DOCS=( NEWS README.md )
	meson_src_install
	font_src_install
}
