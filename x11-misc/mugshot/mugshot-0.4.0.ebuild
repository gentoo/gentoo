# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eapi7-ver gnome2-utils

DESCRIPTION="A lightweight user-configuration application"
HOMEPAGE="https://launchpad.net/mugshot"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome libreoffice pidgin webcam"

RDEPEND="dev-libs/gobject-introspection
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	sys-apps/accountsservice
	x11-libs/gtk+:3
	gnome? ( gnome-base/gnome-control-center )
	libreoffice? ( || ( app-office/libreoffice-bin app-office/libreoffice ) )
	pidgin? ( net-im/pidgin[${PYTHON_USEDEP}] )
	webcam? ( media-libs/gstreamer:1.0
		media-libs/gst-plugins-good:1.0
		gnome? ( media-libs/clutter-gtk[introspection]
			media-video/cheese[introspection] ) )"

DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	dev-util/intltool
	${RDEPEND}"

PATCHES=(
	# https://bugs.launchpad.net/ubuntu/+source/mugshot/+bug/1443283
	"${FILESDIR}/fix_env_spawn_args.patch"
	# Both patches are taken from Arch Linux
	"${FILESDIR}/missing_default_face.patch"
	"${FILESDIR}/use_office_phone.patch"
)

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
