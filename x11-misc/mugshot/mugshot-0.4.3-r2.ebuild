# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="A lightweight user-configuration application"
HOMEPAGE="https://github.com/bluesabre/mugshot"
SRC_URI="https://github.com/bluesabre/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome libreoffice webcam"

COMMON_DEPEND="
	dev-libs/gobject-introspection
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]

"

RDEPEND="
	${COMMON_DEPEND}
	dev-python/pycairo[${PYTHON_USEDEP}]
	sys-apps/accountsservice
	sys-apps/shadow
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
	${COMMON_DEPEND}
	x11-libs/gtk+:3[introspection]
"

BDEPEND="
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	dev-util/intltool
"

python_install() {
	distutils-r1_python_install

	python_optimize

	# Since DOCS are installed twice, remove the wrong path
	rm -r "${ED}"/usr/share/doc/mugshot || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
