# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Parser for the manifest files in the ament buildsystem"
HOMEPAGE="https://github.com/ament/ament_package"
SRC_URI="https://github.com/ament/ament_package/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="test? ( dev-python/flake8[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
