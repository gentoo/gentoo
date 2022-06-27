# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=26

# The upstream does not create git tags for releases.
# This commit hash corresponds to a bump to 0.1.12 and was published to
# MELPA.
MY_HASH=0d6111b36a66013aa9b452e664c93308df3b07e1

inherit elisp

DESCRIPTION="Advanced, type aware, highlight support for CMake"
HOMEPAGE="https://github.com/Lindydancer/cmake-font-lock"
SRC_URI="https://github.com/Lindydancer/${PN}/archive/${MY_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_HASH}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

RDEPEND="dev-util/cmake[emacs]"
DEPEND="${RDEPEND}"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
