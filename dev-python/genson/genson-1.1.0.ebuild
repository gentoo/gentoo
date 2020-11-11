# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7})

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="GenSON is a powerful, user-friendly JSON Schema generator built in Python"
HOMEPAGE="https://pypi.org/project/genson https://github.com/wolverdude/genson"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="
	${PYTHON_DEPS}
	"

RDEPEND="
	${PYTHON_DEPS}
	"
DEPEND="${RDEPEND}
	test? ( dev-python/jsonschema[${PYTHON_USEDEP}] )"

RESTRICT="!test? ( test )"

python_test() {
	"${PYTHON}" -m unittest discover || die "Testing failed with ${EPYTHON}"
}
