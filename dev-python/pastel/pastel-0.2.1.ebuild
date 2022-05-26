# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Bring colors to your terminal"
HOMEPAGE="https://github.com/sdispater/pastel"
SRC_URI="https://github.com/sdispater/pastel/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"

distutils_enable_tests pytest
