# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )

inherit linux-info udev xdg distutils-r1

DESCRIPTION="A Linux device manager for Logitech's Unifying Receiver peripherals"
HOMEPAGE="https://pwr-solaar.github.io/Solaar/"
SRC_URI="https://github.com/pwr-Solaar/Solaar/archive/${PV/_rc/rc}.tar.gz -> ${P/_rc/rc}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

RDEPEND="
	acct-group/plugdev
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/pyudev-0.13[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]"

S="${WORKDIR}"/Solaar-${PV/_rc/rc}

CONFIG_CHECK="~HID_LOGITECH_DJ ~HIDRAW"

python_prepare_all() {
	# don't autostart (bug #494608)
	sed -i \
		-e '/yield autostart_path/d' \
		setup.py || die

	sed -i -r \
		-e '/yield.*udev.*rules.d/{s,/etc,/lib,g}' \
		setup.py || die

	# grant plugdev group rw access
	sed -i 's/#MODE=/MODE=/' rules.d/42-logitech-unify-permissions.rules || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	dodoc docs/devices.md
	if use doc; then
		dodoc -r docs/*
	fi
}
