# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="The long lost Emacs string manipulation library"
HOMEPAGE="https://github.com/magnars/s.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/magnars/s.el"
else
	SRC_URI="https://github.com/magnars/s.el/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/s.el-${PV}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	edo ./run-tests.sh
}
