# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A calendar framework for Emacs"
HOMEPAGE="https://github.com/kiwanami/emacs-calfw/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/kiwanami/emacs-${PN}"
else
	SRC_URI="https://github.com/kiwanami/emacs-${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/emacs-${P}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="howm"

RDEPEND="
	howm? ( app-emacs/howm )
"
BDEPEND="
	${RDEPEND}
"

DOCS=( CHANGELOG.md readme.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	if ! use howm ; then
		rm calfw-howm.el || die
	fi
}
