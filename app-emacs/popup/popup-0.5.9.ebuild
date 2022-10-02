# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-el-${PV}
NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Visual popup interface library for Emacs"
HOMEPAGE="https://github.com/auto-complete/popup-el/"
SRC_URI="https://github.com/auto-complete/popup-el/archive/v${PV}.tar.gz
	-> ${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DOCS=( README.md )
