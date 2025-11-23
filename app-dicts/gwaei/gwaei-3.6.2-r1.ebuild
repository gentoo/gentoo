# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools gnome2-utils xdg

DESCRIPTION="Japanese-English Dictionary for GNOME"
HOMEPAGE="https://github.com/zakkudo/gwaei"
SRC_URI="https://downloads.sourceforge.net/gwaei/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="gtk hunspell nls mecab test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=net-misc/curl-7.20.0
	>=dev-libs/glib-2.31
	gtk? (
		x11-libs/gtk+:3
		app-text/yelp-tools
	)
	hunspell? ( app-text/hunspell )
	nls? ( virtual/libintl )
	mecab? ( app-text/mecab )"
DEPEND="${RDEPEND}
	gtk? (
		x11-themes/gnome-icon-theme-symbolic
		app-text/yelp-tools
	)"
BDEPEND="
	app-text/rarian
	dev-util/intltool
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.17 )
	test? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/scrollkeeper-dtd
	)"

PATCHES=(
	# Migrate away from gnome-doc-utils (from Debian)
	"${FILESDIR}/${P}-yelp.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with gtk gnome) \
		$(use_enable nls) \
		$(use_with hunspell) \
		$(use_with mecab)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_preinst() {
	if use gtk; then
		gnome2_schemas_savelist
		xdg_pkg_preinst
	fi
}

pkg_postinst() {
	if use gtk; then
		gnome2_schemas_update
		xdg_pkg_postinst
	fi
}

pkg_postrm() {
	if use gtk; then
		gnome2_schemas_update
		xdg_pkg_postrm
	fi
}
