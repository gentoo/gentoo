# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Javascript interface for HexChat"
HOMEPAGE="https://github.com/TingPing/hexchat-javascript"
SRC_URI="https://github.com/TingPing/hexchat-javascript/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-lang/spidermonkey:0
	>=net-irc/hexchat-2.9.6[plugins]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		tc-export CXX PKG_CONFIG
	fi
}

src_install() {
	dodir /usr/share/appdata
	default
	if use examples ; then
		dodoc -r examples
	fi
}
