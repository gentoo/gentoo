# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Project documentation with Markdown."
HOMEPAGE="https://www.mkdocs.org"
SRC_URI="https://github.com/tomchristie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/click-3.3[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7.1[${PYTHON_USEDEP}]
	>=dev-python/livereload-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.5[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-bootstrap-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-bootswatch-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.1[${PYTHON_USEDEP}]
"

src_prepare() {
	default

	# mkdocs works fine with torando 5 on Python 2.7 and 3.4+:
	# See https://github.com/mkdocs/mkdocs/pull/1427#issuecomment-371818250
	sed -i 's#tornado>=4.1,<5.0#tornado>=4.1#' "${S}"/setup.py || die "Failed to fix tornado version"
}

python_test() {
	nosetests mkdocs/tests || die "tests failed under ${EPYTHON}"
}
