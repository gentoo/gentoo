# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Implementation of the XDG Base Directory Specification in Python"
HOMEPAGE="https://github.com/srstevenson/xdg/ https://pypi.org/project/xdg/"
SRC_URI="
	https://github.com/srstevenson/xdg/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# https://bugs.gentoo.org/773415
RDEPEND="!dev-python/pyxdg"

distutils_enable_tests pytest
