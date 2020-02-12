# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Policy Analysis Tools for SELinux"
HOMEPAGE="https://github.com/SELinuxProject/setools/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/setools.git"
else
	SRC_URI="https://github.com/SELinuxProject/setools/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="X test"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/networkx-2.0[${PYTHON_USEDEP}]
	>=sys-libs/libsepol-2.8:=
	>=sys-libs/libselinux-2.8:=
	X? (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	)"

DEPEND="${RDEPEND}
	>=dev-python/cython-0.27
	test? (
		sys-apps/checkpolicy
	)"

python_prepare_all() {
	sed -i "s/'-Werror', //" "${S}"/setup.py || die "failed to remove Werror"
	sed -i "s@^lib_dirs = .*@lib_dirs = ['${ROOT:-/}usr/$(get_libdir)']@" "${S}"/setup.py || \
		die "failed to set lib_dirs"

	use X || local PATCHES=( "${FILESDIR}"/setools-4.2.0-remove-gui.patch )
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
