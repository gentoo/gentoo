# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

COMMIT="02e5872ee2905861e1da06ab5174e1a3f41f0e0b"

DESCRIPTION="Terminal User Interface for docker engine"
HOMEPAGE="https://github.com/TomasTomecek/sen"
SRC_URI="https://github.com/TomasTomecek/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/urwidtrees[${PYTHON_USEDEP}]
	dev-python/docker-py[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/flexmock[${PYTHON_USEDEP}]
	)
	"

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r docs
}

python_test() {
	pytest -vv tests || die "pytest failed"
}
