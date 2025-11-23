# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=d88db4248882da2d4316e76ed673b4ac1fa99ce3
MY_PN=Highlight-Indentation-for-Emacs

inherit elisp

DESCRIPTION="Minor modes to highlight indentation guides in Emacs"
HOMEPAGE="https://github.com/antonj/Highlight-Indentation-for-Emacs/"
SRC_URI="https://github.com/antonj/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${COMMIT}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
