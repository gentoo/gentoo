# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="xterm.js"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A terminal for the web"
HOMEPAGE="https://xtermjs.org/
		https://github.com/xtermjs/xterm.js/"
SRC_URI="https://github.com/xtermjs/xterm.js/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"
