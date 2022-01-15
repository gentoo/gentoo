# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Use to display information about binary files in different file formats"
HOMEPAGE="https://scoding.de/ropper https://github.com/sashs/Ropper"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sashs/Ropper"
else
	SRC_URI="https://github.com/sashs/Ropper/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Ropper-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="z3"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/capstone[python,${PYTHON_USEDEP}]
		dev-libs/keystone[python,${PYTHON_USEDEP}]
		dev-python/filebytes[${PYTHON_USEDEP}]
	')
	z3? ( sci-mathematics/z3[python,${PYTHON_SINGLE_USEDEP}] )
"
DEPEND="${RDEPEND}"

distutils_enable_tests setup.py
