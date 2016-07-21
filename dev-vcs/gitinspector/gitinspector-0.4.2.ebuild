# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Statistical analysis tool for git repositories"
HOMEPAGE="https://github.com/ejwa/gitinspector"
SRC_URI="https://github.com/ejwa/gitinspector/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-vcs/git"
DEPEND="
	test? ( ${RDEPEND} )"

python_prepare_all() {
	[[ ${LC_ALL} == "C" ]] && export LC_ALL="en_US.utf8"
	distutils-r1_python_prepare_all
}
