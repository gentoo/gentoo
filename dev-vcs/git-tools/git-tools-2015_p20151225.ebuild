# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{1..5} )
inherit python-r1

DESCRIPTION="Assorted git-related scripts"
HOMEPAGE="https://github.com/MestreLion/git-tools/"
MY_PV="ff7a07daa6898fd0993180f64bd232aa4def6018"
SRC_URI="https://github.com/MestreLion/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	>=dev-vcs/git-2.5
	>=app-shells/bash-4.0"

MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}

src_compile() {
	:;
}

src_install() {
	SCRIPTS_BASH="git-branches-rename git-clone-subset git-find-uncommited-repos git-rebase-theirs git-strip-merge"
	SCRIPTS_PYTHON="git-restore-mtime"
	dobin $SCRIPTS_BASH
	dobin $SCRIPTS_PYTHON
	for p in $SCRIPTS_PYTHON ; do
		python_replicate_script "${ED}"/usr/bin/$p
	done
	dodoc README.md
}
