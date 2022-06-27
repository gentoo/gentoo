# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=26

# The upstream does not create git tags for releases.
MY_HASH=eece09d1151fd641f31d738b8c62742918993e95

inherit elisp

DESCRIPTION="Macro to simplify repetitive configuration patterns"
HOMEPAGE="https://git.sr.ht/~pkal/setup"
SRC_URI="https://git.sr.ht/~pkal/${PN}/archive/${MY_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_HASH}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
