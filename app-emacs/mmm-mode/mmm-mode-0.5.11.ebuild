# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Enables the user to edit different parts of a file in different major modes"
HOMEPAGE="http://mmm-mode.sourceforge.net/
	https://github.com/dgutov/mmm-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dgutov/${PN}.git"
else
	SRC_URI="https://github.com/dgutov/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="GPL-2+ Texinfo-manual"
SLOT="0"

BDEPEND="sys-apps/texinfo"

DOCS=( AUTHORS FAQ NEWS README README.Mason TODO )
ELISP_TEXINFO="mmm.texi"
SITEFILE="50${PN}-gentoo.el"
