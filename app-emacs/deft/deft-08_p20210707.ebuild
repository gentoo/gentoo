# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=28be94d89bff2e1c7edef7244d7c5ba0636b1296

inherit elisp

DESCRIPTION="Quickly browse, filter and edit directories of plain text notes"
HOMEPAGE="https://github.com/jrblevin/deft/"
SRC_URI="https://github.com/jrblevin/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
