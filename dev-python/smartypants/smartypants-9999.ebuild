# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..10} )
DISTUTILS_USE_SETUPTOOLS=no

MY_PN="${PN}.py"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1

DESCRIPTION="ASCII quote-dot-dash to HTML entity converter"
HOMEPAGE="https://pypi.python.org/pypi/smartypants/"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/leohemsted/smartypants.py.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/leohemsted/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="MIT"
SLOT="0"

distutils_enable_sphinx docs
distutils_enable_tests setup.py
