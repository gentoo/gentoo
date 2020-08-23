# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson readme.gentoo-r1 xdg

DESCRIPTION="Archive manager for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/FileRoller"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
IUSE="libnotify nautilus packagekit"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

# gdk-pixbuf used extensively in the source
# cairo used in eggtreemultidnd.c
# pango used in fr-window
RDEPEND="
	>=app-arch/libarchive-3:=
	>=dev-libs/glib-2.36:2
	>=dev-libs/json-glib-0.14
	>=x11-libs/gtk+-3.13.2:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	libnotify? ( >=x11-libs/libnotify-0.4.3:= )
	nautilus? ( >=gnome-base/nautilus-2.22.2 )
	packagekit? ( app-admin/packagekit-base )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
${PN} is a frontend for several archiving utilities. If you want a
particular archive format support, see ${HOMEPAGE}
and install the relevant package. For example:
7-zip   - app-arch/p7zip
ace     - app-arch/unace
arj     - app-arch/arj
brotli  - app-arch/brotli
cpio    - app-arch/cpio
deb     - app-arch/dpkg
iso     - app-cdr/cdrtools
jar,zip - app-arch/zip and app-arch/unzip
lha     - app-arch/lha
lzop    - app-arch/lzop
lz4     - app-arch/lz4
rar     - app-arch/unrar or app-arch/unar
rpm     - app-arch/rpm
unstuff - app-arch/stuffit
zoo     - app-arch/zoo"

PATCHES=(
	# https://gitlab.gnome.org/GNOME/file-roller/merge_requests/31
	"${FILESDIR}"/${PN}-3.32.4-fno-common.patch
)

src_prepare() {
	# File providing Gentoo package names for various archivers
	cp -v "${FILESDIR}"/3.32-packages.match data/packages.match || die

	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Drun-in-place=false
		$(meson_use nautilus nautilus-actions)
		$(meson_use libnotify notification)
		$(meson_use packagekit)
		-Dlibarchive=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
