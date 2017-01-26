# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{4..5} )
inherit eutils python-r1

DESCRIPTION="Assorted git-related scripts"
HOMEPAGE="https://github.com/MestreLion/git-tools/"
MY_PV="0431b5f4c59101c1b7250d8dd2ce3f6a22318bc6"
SRC_URI="https://github.com/MestreLion/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="
	>=dev-vcs/git-2.5
	>=app-shells/bash-4.0"

MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "$FILESDIR"/git-tools-2015_p20151225-py3.patch
	epatch "$FILESDIR"/${P}-pr21.patch

	epatch_user
}

src_compile() {
	:;
}

src_install() {
	SCRIPTS_BASH="git-branches-rename git-clone-subset git-find-uncommitted-repos git-rebase-theirs git-strip-merge"
	SCRIPTS_PYTHON="git-restore-mtime"
	dobin $SCRIPTS_BASH
	dobin $SCRIPTS_PYTHON
	for p in $SCRIPTS_PYTHON ; do
		python_replicate_script "${ED}"/usr/bin/$p
	done
	# Make it possible to use the tools as 'git $TOOLNAME'
	for i in $SCRIPTS_BASH $SCRIPTS_PYTHON ; do
		dosym /usr/bin/$i /usr/libexec/git-core/$i
	done
	dodoc README.md
}
