# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Push Notifications that work with just about every platform"
HOMEPAGE="
	https://pypi.org/project/apprise/
	https://github.com/caronc/apprise/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv"
IUSE="+dbus mqtt"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	mqtt? ( dev-python/paho-mqtt[${PYTHON_USEDEP}] )
"
BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
