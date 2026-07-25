# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

MY_PN="py3status"
MY_P="${MY_PN}-${PV/_/-}"

DESCRIPTION="py3status is an extensible i3status wrapper written in python"
HOMEPAGE="https://github.com/ultrabug/py3status"
SRC_URI="https://github.com/ultrabug/py3status/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal +dbus +udev"

RDEPEND="
	!minimal? ( x11-misc/i3status )
	dbus? ( >=dev-python/dbus-python-1.3.2[${PYTHON_USEDEP}] >=dev-python/pygobject-3.46.0[${PYTHON_USEDEP}] )
	udev? ( >=dev-python/pyudev-0.21.0[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
