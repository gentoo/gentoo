# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1 udev linux-info gnome2-utils

DESCRIPTION="A Linux device manager for Logitech's Unifying Receiver peripherals"
HOMEPAGE="https://pwr.github.com/Solaar/"
SRC_URI="https://github.com/pwr/Solaar/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc"

RDEPEND="
	acct-group/plugdev
	>=dev-python/pyudev-0.13[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]"

S=${WORKDIR}/Solaar-${PV}

CONFIG_CHECK="~HID_LOGITECH_DJ ~HIDRAW"

python_prepare_all() {
	# don't autostart (bug #494608)
	sed -i '/yield autostart_path/d' setup.py || die

	# grant plugdev group rw access
	sed -i 's/#MODE=/MODE=/' rules.d/42-logitech-unify-permissions.rules || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	udev_dorules rules.d/*.rules

	dodoc docs/devices.md
	if use doc; then
		dodoc -r docs/*
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Users must be in the plugdev group to use this application."
	fi

	gnome2_icon_cache_update
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postrm() { gnome2_icon_cache_update; }
