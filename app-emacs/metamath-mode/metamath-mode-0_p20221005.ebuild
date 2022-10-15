# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=85bd63b88378e9f2dee2f7d5585ec6610bf098a6

inherit elisp

DESCRIPTION="Major GNU Emacs mode for metamath files"
HOMEPAGE="https://github.com/samrushing/metamath-mode/"
SRC_URI="https://github.com/samrushing/${PN}/archive/${H}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
