# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="GNU Emacs mode for handling Dockerfiles"
HOMEPAGE="https://github.com/spotify/dockerfile-mode/"
SRC_URI="https://github.com/spotify/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
