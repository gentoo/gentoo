# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

COMMIT_HASH="e3a38d93e01014cd47bf5af4924459bd145fd7c4"

DESCRIPTION="Unobtrusively trim extraneous white-space *ONLY* in lines edited"
HOMEPAGE="https://github.com/lewang/ws-butler"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URL="https://github.com/lewang/${PN}.git"
else
	SRC_URI="https://github.com/lewang/${PN}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT_HASH}"
fi

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
