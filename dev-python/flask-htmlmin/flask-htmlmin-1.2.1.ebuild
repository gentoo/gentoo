# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

MY_PN="Flask-HTMLmin"
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Minimize your flask rendered html"
HOMEPAGE="https://github.com/hamidfzm/Flask-HTMLmin"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-text/htmlmin
	dev-python/flask
"

S="${WORKDIR}/${MY_P}"
