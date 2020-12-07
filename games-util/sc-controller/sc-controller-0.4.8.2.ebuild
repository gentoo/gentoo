# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 xdg

DESCRIPTION="User-mode driver and GTK-based GUI for Steam Controllers and others"
HOMEPAGE="https://github.com/Ryochan7/sc-controller/"
SRC_URI="https://github.com/Ryochan7/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+udev"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_USEDEP},cairo]
		dev-python/pylibacl[${PYTHON_USEDEP}]
		dev-python/python-evdev[${PYTHON_USEDEP}]
	')
	gnome-base/librsvg
	x11-libs/gtk+:3
	udev? ( games-util/game-device-udev-rules )
"
