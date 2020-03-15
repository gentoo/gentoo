# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

DESCRIPTION="Python job scheduling for humans"
HOMEPAGE="https://github.com/dbader/schedule"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/dbader/schedule"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/dbader/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}] )
"

python_test() {
	python_export PYTHON_SITEDIR PYTHON_SCRIPTDIR
	py.test test_schedule.py || die "Testing failed with ${EPYTHON}"
}
