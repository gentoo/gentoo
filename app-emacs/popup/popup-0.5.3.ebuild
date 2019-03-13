# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_P="${PN}-el-${PV}"
DESCRIPTION="Visual popup interface library for Emacs"
HOMEPAGE="https://github.com/auto-complete/popup-el"
SRC_URI="https://github.com/auto-complete/popup-el/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

S="${WORKDIR}/${MY_P}"
DOCS="README.md"
