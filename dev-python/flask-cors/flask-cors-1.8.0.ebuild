# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-cors/flask-cors-1.8.0.ebuild,v 1.2 2014/09/14 18:26:54 floppym Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN="Flask-Cors"
MY_P="${MY_PN}-${PV}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/wcdolphin/${PN}.git"
	SRC_URI=""
else
	SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A Flask extension for Cross Origin Resource Sharing (CORS)"
HOMEPAGE="https://github.com/wcdolphin/flask-cors https://pypi.python.org/pypi/Flask-Cors"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

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
