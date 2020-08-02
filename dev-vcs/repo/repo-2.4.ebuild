# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NB: The $PV tracks the *repo launcher version*, not the last signed release
# of the repo project.  The launcher only gets a new update when changes are
# made in it.

EAPI="7"

PYTHON_COMPAT=( python3_{6..8} )

inherit python-r1

DESCRIPTION="Google tool for managing git, particularly multiple repos"
HOMEPAGE="https://gerrit.googlesource.com/git-repo"
SRC_URI="https://storage.googleapis.com/git-repo-downloads/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	!app-admin/radmind
	!dev-util/repo"

S=${WORKDIR}

src_install() {
	python_foreach_impl python_newscript "${DISTDIR}/${P}" ${PN}
}
