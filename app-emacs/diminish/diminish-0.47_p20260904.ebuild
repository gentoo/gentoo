# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Hiding or abbreviation of the mode line displays (lighters)"
HOMEPAGE="https://github.com/myrjola/diminish.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/myrjola/${PN}.el"
else
	[[ "${PV}" == *p20260904 ]] && COMMIT=43d0b9e0d18e4d124e3f7dad9d73275fb678fa50
	SRC_URI="https://github.com/myrjola/${PN}.el/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}.el-${COMMIT}"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
