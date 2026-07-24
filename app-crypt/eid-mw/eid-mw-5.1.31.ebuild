# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop gnome2-utils

DESCRIPTION="Electronic Identity Card middleware supplied by the Belgian Federal Government"
HOMEPAGE="https://eid.belgium.be"
SRC_URI="https://codeload.github.com/fedict/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+dialogs +gtk p11-kit"

RDEPEND="sys-apps/pcsc-lite
	gtk? (
		x11-libs/gdk-pixbuf[jpeg]
		x11-libs/gtk+:3
		dev-libs/libxml2:=
		net-misc/curl[ssl]
		net-libs/libproxy
		app-crypt/pinentry[gtk]
	)
	p11-kit? ( app-crypt/p11-kit )"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="dialogs? ( gtk )"

PATCHES=(
	"${FILESDIR}/0001-Do-not-build-xpi-module.patch"
	"${FILESDIR}/0001-Fix-libdir-for-manifestdir.patch"
	"${FILESDIR}/0001-Remove-uml-build.patch"
	)

src_prepare() {
	default

	# Buggy internal versioning when autoreconf a tarball release.
	# Weird numbering is required otherwise we get a seg fault in
	# about-eid-mw program.
	echo "${PV}-v${PV}" > .version

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable dialogs) \
		$(use_enable p11-kit p11kit) \
		$(use_with gtk gtkvers '3') \
		--with-gnu-ld
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
	if use gtk; then
		domenu plugins_tools/eid-viewer/eid-viewer.desktop
		doicon plugins_tools/eid-viewer/gtk/eid-viewer.png
	fi
}

pkg_postinst() {
	if use gtk; then
		gnome2_schemas_update
		xdg_desktop_database_update
		xdg_icon_cache_update

		local peimpl=$(eselect --brief --colour=no pinentry show)
		case "${peimpl}" in
		*gnome*|*qt*) ;;
		*)	ewarn "The pinentry front-end currently selected is not supported by eid-mw."
			ewarn "You may be prompted for your pin code in an inaccessible shell!!"
			ewarn "Please select pinentry-gnome3 as default pinentry provider:"
			ewarn " # eselect pinentry set pinentry-gnome3"
		;;
		esac
	fi
}

pkg_postrm() {
	if use gtk; then
		gnome2_schemas_update
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
