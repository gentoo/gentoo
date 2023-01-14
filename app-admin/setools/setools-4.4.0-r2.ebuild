# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Policy Analysis Tools for SELinux"
HOMEPAGE="https://github.com/SELinuxProject/setools/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/setools.git"
else
	SRC_URI="https://github.com/SELinuxProject/setools/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="amd64 arm arm64 x86"
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="test infoflow X"
RESTRICT="!test? ( test )"
S="${WORKDIR}/${PN}"

RDEPEND="${PYTHON_DEPS}
	dev-python/setuptools
	>=sys-libs/libsepol-3.2:=
	>=sys-libs/libselinux-3.2:=
	infoflow? ( >=dev-python/networkx-2.0[${PYTHON_USEDEP}] )
	X? (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-python/cython-0.27
	dev-python/setuptools
	test? (
		>=dev-python/networkx-2.0[${PYTHON_USEDEP}]
		sys-apps/checkpolicy
	)"

python_prepare_all() {
	sed -i "s/'-Werror', //" "${S}"/setup.py || die "failed to remove Werror"
	sed -i "s@^lib_dirs = .*@lib_dirs = ['${ROOT:-/}usr/$(get_libdir)']@" "${S}"/setup.py || \
		die "failed to set lib_dirs"

	local PATCHES=( "${FILESDIR}"/0001-__init__.py-Make-NetworkX-dep-optional.patch )
	use X || PATCHES+=( "${FILESDIR}"/setools-4.4.0-remove-gui.patch )
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
