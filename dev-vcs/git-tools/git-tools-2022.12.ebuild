# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit python-r1

DESCRIPTION="Assorted git-related scripts"
HOMEPAGE="https://github.com/MestreLion/git-tools"
SRC_URI="https://github.com/MestreLion/git-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	${DEPEND}
	>=app-shells/bash-4.0
	>=dev-vcs/git-2.5
"

src_install() {
	dobin git-branches-rename git-clone-subset git-find-uncommitted-repos
	dobin git-rebase-theirs git-strip-merge
	python_foreach_impl python_doscript git-restore-mtime
	doman man1/*.1
	einstalldocs
}
