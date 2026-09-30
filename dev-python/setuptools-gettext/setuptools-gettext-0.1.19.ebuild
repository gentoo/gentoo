# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/breezy-team/setuptools-gettext
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Setuptools plugin for building mo files"
HOMEPAGE="
	https://pypi.org/project/setuptools-gettext/
	https://github.com/breezy-team/setuptools-gettext/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/setuptools-69[${PYTHON_USEDEP}]
	sys-devel/gettext
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
