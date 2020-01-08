# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Flask-Cors"
MY_P="${MY_PN}-${PV}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-2
	EGIT_REPO_URI="https://github.com/wcdolphin/${PN}.git"
	SRC_URI=""
else
	SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A Flask extension for Cross Origin Resource Sharing (CORS)"
HOMEPAGE="https://github.com/wcdolphin/flask-cors https://pypi.org/project/Flask-Cors/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_test() {
	esetup.py test
}
