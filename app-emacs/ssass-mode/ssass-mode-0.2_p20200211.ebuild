# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20200211 ]] && COMMIT=96f557887ad97a0066a60c54f92b7234b8407016

inherit elisp

DESCRIPTION="Write Sass in Emacs without a Turing Machine"
HOMEPAGE="https://github.com/AdamNiederer/ssass-mode/"
SRC_URI="https://github.com/AdamNiederer/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
