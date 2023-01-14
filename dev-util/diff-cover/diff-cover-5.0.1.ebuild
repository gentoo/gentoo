# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_9 )
DISTUTILS_USE_SETUPTOOLS="bdepend"
inherit distutils-r1

DESCRIPTION="Find diff lines that do not have test coverage"
HOMEPAGE="https://mesonbuild.com/"
SRC_URI="https://github.com/Bachmann1234/diff_cover/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/diff-cover/diff_cover}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/chardet-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7.1[${PYTHON_USEDEP}]
	dev-python/jinja2_pluralize[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
