# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="xml(+)"

inherit edo meson python-single-r1

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Mirrorselect"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/mirrorselect.git"
	inherit git-r3
	# This is only here to ensure mirrorselect-test exists on gentoo mirrors
	SRC_URI="https://dev.gentoo.org/~dolsen/releases/mirrorselect/mirrorselect-test"
else
	SRC_URI="https://gitweb.gentoo.org/proj/mirrorselect.git/snapshot/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
LICENSE="GPL-2"
SLOT="0"

BDEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
	dev-util/dialog
	>=net-analyzer/netselect-0.4
	$(python_gen_cond_dep '
		dev-python/requests[${PYTHON_USEDEP}]
		sys-apps/portage[${PYTHON_USEDEP}]
	')
"

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"
	python_optimize
}
