# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8,9,10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

inherit distutils-r1

DESCRIPTION="Extra Python Collections - bags (multisets) and setlists (ordered sets)"
HOMEPAGE="https://github.com/mlenzen/collections-extended https://collections-extended.lenzm.net/ https://pypi.org/project/collections-extended/"
SRC_URI="https://github.com/mlenzen/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
