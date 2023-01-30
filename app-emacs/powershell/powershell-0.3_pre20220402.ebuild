# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=77b27faf8a292f1dc9f54c872241dc53b6791bf1
NEED_EMACS=24

inherit elisp

DESCRIPTION="GNU Emacs mode for editing and running PowerShell code"
HOMEPAGE="https://github.com/jschaf/powershell.el/"
SRC_URI="https://github.com/jschaf/${PN}.el/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
