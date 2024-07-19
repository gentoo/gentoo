# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Policy Analysis Tools for SELinux"
HOMEPAGE="https://github.com/SELinuxProject/setools/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/setools.git"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/SELinuxProject/setools/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="test X"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/networkx-2.6[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=sys-libs/libsepol-3.2:=
	>=sys-libs/libselinux-3.2:=
	X? (
		dev-python/PyQt6[gui,widgets,${PYTHON_USEDEP}]
		dev-python/pygraphviz[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-python/cython-0.29.14[${PYTHON_USEDEP}]
	test? (
		dev-python/PyQt6[gui,testlib,widgets,${PYTHON_USEDEP}]
		dev-python/pytest-qt[${PYTHON_USEDEP}]
		sys-apps/checkpolicy
	)"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i "s@^lib_dirs = .*@lib_dirs = ['${ROOT:-/}usr/$(get_libdir)']@" "${S}"/setup.py || \
		die "failed to set lib_dirs"

	use X || PATCHES+=( "${FILESDIR}"/setools-4.5.1-remove-gui.patch )
	distutils-r1_python_prepare_all
}

python_test() {
	rm -rf setools || die
	epytest
}
