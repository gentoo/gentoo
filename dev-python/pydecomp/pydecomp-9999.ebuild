# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 python-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/dol-sen/pyDeComp.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~dolsen/releases/${PN}/pyDeComp-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
	S="${WORKDIR}/pyDeComp-${PV}"
fi

DESCRIPTION="A python library of common (de)compression and contents handling"
HOMEPAGE="https://github.com/dol-sen/pyDeComp"

LICENSE="BSD"
SLOT="0"
IUSE=""

python_install_all() {
	distutils-r1_python_install_all
}

pkg_postinst() {
	einfo
	einfo "This is new software."
	einfo "The API's it installs should be considered unstable"
	einfo "and are subject to change."
	einfo
	einfo "Please file any enhancement requests, or bugs"
	einfo "at https://github.com/dol-sen/pyDeComp/issues"
	einfo "I am also on IRC @ #gentoo-releng of the freenode network"
	einfo
	ewarn "There may be some python 3 compatibility issues still."
	ewarn "Please help debug/fix/report them in github or bugzilla."
}
