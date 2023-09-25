# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} = *_p20221110 ]] && COMMIT=c35c35bdf5ce2d992882c1f06f0f078058870d4a

inherit elisp

DESCRIPTION="GNU Emacs version of the Vim powerline"
HOMEPAGE="https://github.com/milkypostman/powerline/"
SRC_URI="https://github.com/milkypostman/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
