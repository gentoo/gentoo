# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="SqlAlchemy schema display script"
HOMEPAGE="https://bitbucket.org/estin/sadisplay/wiki/Home"
COMMIT_ID="d67d12894ebd"
SRC_URI="https://bitbucket.org/estin/sadisplay/get/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/sqlalchemy[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
	"
S="${WORKDIR}/estin-${PN}-${COMMIT_ID}"

python_test() {
	nosetests -v || die
}
