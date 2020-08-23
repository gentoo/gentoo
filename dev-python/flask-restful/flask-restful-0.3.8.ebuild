# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Simple framework for creating REST APIs"
HOMEPAGE="https://flask-restful.readthedocs.io/en/latest/ https://github.com/twilio/flask-restful/"
SRC_URI="https://github.com/twilio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="examples"

RDEPEND="
	>=dev-python/aniso8601-0.82[${PYTHON_USEDEP}]
	>=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.3.0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests nose

PATCHES=(
	"${FILESDIR}"/flask-restful-0.3.8-werkzeug.patch
)

python_install_all() {
	use examples && dodoc -r examples
	local DOCS=( AUTHORS.md CHANGES.md CONTRIBUTING.md README.md )

	distutils-r1_python_install_all
}
