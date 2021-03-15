# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NB: The $PV tracks the *repo launcher version*, not the last signed release
# of the repo project.  The launcher only gets a new update when changes are
# made in it.

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )

inherit bash-completion-r1 python-r1

# This file rarely changes, so track it independently.
COMP_VER="511a0e54f5801a3f36c00fac478a596d83867d10"
COMP_NAME="${PN}-${COMP_VER}-bash-completion.sh.base64"

DESCRIPTION="Google tool for managing git, particularly multiple repos"
HOMEPAGE="https://gerrit.googlesource.com/git-repo"
SRC_URI="https://storage.googleapis.com/git-repo-downloads/${P}
	https://gerrit.googlesource.com/git-repo/+/${COMP_VER}/completion.bash?format=TEXT -> ${COMP_NAME}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	!app-admin/radmind
	!dev-util/repo"

S=${WORKDIR}

src_unpack() {
	base64 -d <"${DISTDIR}/${COMP_NAME}" >completion.bash || die
}

src_install() {
	python_foreach_impl python_newscript "${DISTDIR}/${P}" ${PN}
	newbashcomp completion.bash ${PN}
}
