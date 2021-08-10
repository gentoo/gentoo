# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

MY_PN=xdot.py
EGIT_REPO_URI="https://github.com/jrfonseca/${MY_PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/jrfonseca/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

inherit ${GIT_ECLASS} distutils-r1

DESCRIPTION="Interactive viewer for Graphviz dot files"
HOMEPAGE="https://github.com/jrfonseca/xdot.py"

LICENSE="LGPL-2+"
SLOT="0"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	media-gfx/graphviz
"
RDEPEND="${DEPEND}"
