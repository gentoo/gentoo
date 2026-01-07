# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit autotools python-single-r1 xdg

DESCRIPTION="GTK HTML editor for the experienced web designer or programmer"
HOMEPAGE="https://bluefish.openoffice.nl/"
SRC_URI="https://www.bennewitz.com/bluefish/stable/source/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="gucharmap nls python spell"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	virtual/zlib:=
	gucharmap? ( gnome-extra/gucharmap:2.90 )
	python? ( ${PYTHON_DEPS} )
	spell? ( app-text/enchant:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2
	virtual/pkgconfig
	x11-libs/gdk-pixbuf
	nls? ( sys-devel/gettext )
"

# there actually is just some broken manpage checkup -> not bother
RESTRICT="test"

PATCHES=(
	# https://sourceforge.net/p/bluefish/tickets/111/
	"${FILESDIR}/${PN}-2.2.9-charmap_configure.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoconf
}

src_configure() {
	export CONFIG_SHELL="${BASH}"
	local myeconfargs=(
		--disable-update-databases
		--disable-xml-catalog-update
		--with-freedesktop_org-appdata="${EPREFIX}"/usr/share/metainfo
		--without-gtk2
		$(use_with gucharmap charmap)
		$(use_enable nls)
		$(use_enable spell spell-check)
		$(use_enable python)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use python; then
		python_fix_shebang "${ED}/usr/share/bluefish"
		python_optimize "${ED}/usr/share/bluefish/plugins/zencoding"
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_pkg_postinst

	einfo "Adding XML catalog entries..."
	"${EPREFIX}"/usr/bin/xmlcatalog  --noout \
		--add 'public' 'Bluefish/DTD/Bflang' 'bflang.dtd' \
		--add 'system' 'http://bluefish.openoffice.nl/DTD/bflang.dtd' 'bflang.dtd' \
		--add 'rewriteURI' 'http://bluefish.openoffice.nl/DTD' '/usr/share/xml/bluefish-unstable' \
		"${EROOT}"/etc/xml/catalog \
		|| ewarn "Failed to add XML catalog entries."
}

pkg_postrm() {
	xdg_pkg_postrm

	einfo "Removing XML catalog entries..."
	"${EPREFIX}"/usr/bin/xmlcatalog  --noout \
		--del 'Bluefish/DTD/Bflang' \
		--del 'http://bluefish.openoffice.nl/DTD/bflang.dtd' \
		--del 'http://bluefish.openoffice.nl/DTD' \
		"${EROOT}"/etc/xml/catalog \
		|| ewarn "Failed to remove XML catalog entries."
}
