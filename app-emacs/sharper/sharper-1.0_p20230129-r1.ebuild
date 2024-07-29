# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION=".NET SDK CLI wrapper for GNU Emacs using Transient"
HOMEPAGE="https://github.com/sebasmonia/sharper/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sebasmonia/${PN}.git"
else
	[[ "${PV}" == *_p20230129 ]] && COMMIT=496e90e337cb09329d85a6d171c0953a85e918fe

	SRC_URI="https://github.com/sebasmonia/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	app-emacs/transient
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
