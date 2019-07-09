# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_5 )
inherit python-r1

DESCRIPTION="Assorted git-related scripts"
HOMEPAGE="https://github.com/MestreLion/git-tools/"
MY_PV="ff7a07daa6898fd0993180f64bd232aa4def6018"
SRC_URI="https://github.com/MestreLion/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-vcs/git-2.5
	>=app-shells/bash-4.0"

MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "$FILESDIR"/git-tools-2015_p20151225-py3.patch
}

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
	# Make it possible to use the tools as 'git $TOOLNAME'
	for i in $SCRIPTS_BASH $SCRIPTS_PYTHON ; do
		dosym /usr/bin/$i /usr/libexec/git-core/$i
	done
	dodoc README.md
}
