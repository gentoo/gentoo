# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="Policy Analysis Tools for SELinux"
HOMEPAGE="https://github.com/TresysTechnology/setools/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TresysTechnology/setools.git"
else
	SRC_URI="https://github.com/TresysTechnology/setools/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=""
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="X debug test"

RDEPEND="${PYTHON_DEPS}
	>=sys-libs/libselinux-2.4:=[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.8[${PYTHON_USEDEP}]
	app-arch/bzip2:=
	dev-libs/libpcre:=
	X? (
	    dev-python/PyQt5
	)"

DEPEND="${RDEPEND}
	>=dev-lang/swig-2.0.12:0
	sys-devel/bison
	sys-devel/flex
	>=sys-libs/libsepol-2.5
	test? (
		python_targets_python2_7? ( dev-python/mock[${PYTHON_USEDEP}] )
		dev-python/tox[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i "s/'-Werror', //" "${S}"/setup.py || die "failed to remove Werror"

	use X || local PATCHES=( "${FILESDIR}"/setools-4.0.1-remove-gui.patch )
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
