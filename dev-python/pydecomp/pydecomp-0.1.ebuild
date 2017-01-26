# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 python-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="git://github.com/dol-sen/pyDeComp.git"
	inherit git-2
else
	SRC_URI="https://dev.gentoo.org/~dolsen/releases/${PN}/pyDeComp-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
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
