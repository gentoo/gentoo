# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="A lightweight user-configuration application"
HOMEPAGE="https://github.com/bluesabre/mugshot"
SRC_URI="https://github.com/bluesabre/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome libreoffice webcam"

RDEPEND="
	dev-libs/gobject-introspection
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	sys-apps/accountsservice
	x11-libs/gtk+:3
	gnome? ( gnome-base/gnome-control-center )
	libreoffice? (
		|| (
			app-office/libreoffice-bin
			app-office/libreoffice
		)
	)
	webcam? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-good:1.0
		gnome? (
			media-libs/clutter-gtk[introspection]
			media-video/cheese[introspection]
		)
	)
"

DEPEND="
	${RDEPEND}
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-util/intltool
"

S="${WORKDIR}/${PN}-${P}"

python_install() {
	distutils-r1_python_install

	# Since DOCS are installed twice, remove the wrong path
	rm -r "${ED%/}"/usr/share/doc/mugshot || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
