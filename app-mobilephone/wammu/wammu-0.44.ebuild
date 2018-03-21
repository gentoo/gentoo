# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Front-end for gammu to access mobile phones easily"
HOMEPAGE="https://www.wammu.eu/"
SRC_URI="http://dl.cihar.com/wammu/v0/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth gnome"

RDEPEND="
	>=app-mobilephone/gammu-1.36
	dev-python/python-gammu
	>=dev-python/wxpython-2.8:*[${PYTHON_USEDEP}]
	bluetooth? (
		dev-python/pybluez[${PYTHON_USEDEP}]
		gnome? ( net-wireless/gnome-bluetooth )
	)
"
DEPEND="${RDEPEND}"

# Required to source locale content out of the box
DISTUTILS_IN_SOURCE_BUILD=1

# SKIPWXCHECK: else 'import wx' results in
# Xlib: connection to ":0.0" refused by server
SKIPWXCHECK=yes
