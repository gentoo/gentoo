# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit meson flag-o-matic gnome2-utils optfeature python-single-r1 virtualx xdg

DESCRIPTION="A file manager for Cinnamon, forked from Nautilus"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/nemo"
SRC_URI="https://github.com/linuxmint/nemo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+ FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="exif gtk-doc +nls selinux test tracker wayland xmp"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# https://github.com/linuxmint/nemo/issues/2501
RESTRICT="test"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=app-accessibility/at-spi2-core-2.46.0:2
	>=dev-libs/glib-2.45.7:2[dbus]
	>=dev-libs/gobject-introspection-1.82.0-r2:=
	>=dev-libs/json-glib-1.6.0
	dev-libs/libxmlb:0/2[introspection]
	>=gnome-extra/cinnamon-desktop-6.6:0=
	gnome-extra/libgsf:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.24.41-r1:3[introspection,wayland?,X]
	x11-libs/libX11
	>=x11-libs/pango-1.40.0
	>=x11-libs/xapp-3.2.2[introspection]

	exif? (
		>=media-libs/libexif-0.6.20
	)
	selinux? (
		sys-libs/libselinux
	)
	tracker? (
		app-misc/tinysparql:3
	)
	xmp? (
		>=media-libs/exempi-2.2.0:=
	)
"
RDEPEND="
	${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	x11-themes/xapp-symbolic-icon-theme

	nls? (
		>=gnome-extra/cinnamon-translations-6.6
	)
"
PDEPEND="
	>=gnome-base/gvfs-0.1.2
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	>=dev-util/gdbus-codegen-2.80.5-r1
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	virtual/pkgconfig

	gtk-doc? (
		dev-util/gtk-doc
	)
"

PATCHES=(
	# Undo the switch to untex as it's not packaged.
	"${FILESDIR}/${PN}-5.0.3-use-detex.patch"
)

src_prepare() {
	default
	python_fix_shebang files/usr/share/nemo/actions install-scripts
}

src_configure() {
	# defang automagic dependencies
	use wayland || append-cflags -DGENTOO_GTK_HIDE_WAYLAND

	local emesonargs=(
		$(meson_use exif)
		$(meson_use xmp)
		$(meson_use selinux)
		$(meson_use tracker)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	optfeature "archive file mounting" sys-apps/gnome-disk-utility
	optfeature "archive file extract/create from the context menu" gnome-extra/nemo-fileroller

	optfeature_header "Install additional packages to make their associated file types searchable:"
	optfeature "EPUB" "app-arch/unzip app-text/html2text"
	optfeature "image metadata" media-gfx/exif
	optfeature "MP3 tags" media-sound/id3
	optfeature "Microsoft Office .doc" app-text/catdoc
	optfeature "Microsoft Office .xls" dev-python/xlrd
	optfeature "PDF" "app-text/poppler[utils]"
	optfeature "PostScript" app-text/ghostscript-gpl
	optfeature "TeX" app-text/texlive-core
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
