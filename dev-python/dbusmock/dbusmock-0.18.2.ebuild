# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Easily create mock objects on D-Bus for software testing"
HOMEPAGE="https://github.com/martinpitt/python-dbusmock"
SRC_URI="https://github.com/martinpitt/${MY_PN}/releases/download/${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-17.1[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/0.18.2-disable-polkitd-tests.patch
)

python_test() {
	nosetests --verbose || die "tests fail under ${EPYTHON}"
}

python_install_all() {
	local DOCS=( NEWS README.rst )

	distutils-r1_python_install_all
}
