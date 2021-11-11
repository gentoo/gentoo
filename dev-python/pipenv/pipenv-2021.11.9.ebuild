# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PV=${PV/_beta/b}
DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="https://github.com/pypa/pipenv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-${PV//./-}-remove-attr-vendor-import.patch"
	"${FILESDIR}/${PN}-${PV//./-}-remove-colorama-vendor-import.patch"
	)

RDEPEND="
	${PYTHON_DEPS}
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0.1[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
	dev-python/virtualenv-clone[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.36.0[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# remove vendored versions
	# see https://bugs.gentoo.org/717666
	rm -vR "${S}/${PN}/vendor/attr/" || die
	rm -vR "${S}/${PN}/vendor/colorama/" || die
	rm -vR "${S}/${PN}/vendor/requests/" || die
	# not actually used by pipenv, but included in pipenv
	rm -vR "${S}/${PN}/vendor/jinja2/" || die
	rm -vR "${S}/${PN}/vendor/wheel/" || die
	distutils-r1_src_prepare
}

python_test() {
	pytest -vvv -x -m "not cli and not needs_internet" tests/unit/ || die
}
