# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Python module for native access to the systemd facilities"
HOMEPAGE="https://github.com/systemd/python-systemd"
SRC_URI="https://github.com/systemd/python-systemd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	sys-apps/systemd:0=
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	!sys-apps/systemd[python(-)]
"

PATCHES=(
	"${FILESDIR}"/233-xfail-bind.patch
)

python_test() {
	pushd "${BUILD_DIR}/lib" > /dev/null || die
	"${EPYTHON}" -m pytest -v . || die
	popd > /dev/null || die
}
