# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

TOML_TEST_COMMIT="fa9501a192b7c46b82059caddaef978e3de883dc"

DESCRIPTION="A TOML-0.4.0 parser/writer for Python"
HOMEPAGE="https://github.com/avakar/pytoml"
SRC_URI="https://github.com/avakar/pytoml/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/avakar/toml-test/archive/${TOML_TEST_COMMIT}.tar.gz -> toml-test-${TOML_TEST_COMMIT}.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	cp -R ../toml-test-${TOML_TEST_COMMIT}/* test/toml-test/ || die
	${EPYTHON} test/test.py || die
}
