# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs Image Manipulation Package"
HOMEPAGE="https://github.com/nicferrier/eimp/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nicferrier/${PN}.git"
else
	[[ ${PV} == 1.4.0 ]] && COMMIT=2e7536fe6d8f7faf1bad7a8ae37faba0162c3b4f
	SRC_URI="https://github.com/nicferrier/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="media-gfx/imagemagick"

SITEFILE="50${PN}-gentoo.el"
