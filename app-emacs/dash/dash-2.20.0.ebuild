# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A modern list library for Emacs"
HOMEPAGE="https://github.com/magnars/dash.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magnars/dash.el"
else
	SRC_URI="https://github.com/magnars/dash.el/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"

	KEYWORDS="~alpha amd64 ~arm arm64 ~loong ppc64 ~riscv ~sparc x86 ~x64-macos"
fi

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	sys-apps/texinfo
"

DOCS=( README.md )
ELISP_TEXINFO="dash.texi"
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -l "${S}/dev/examples.el"
