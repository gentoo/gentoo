# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit common-lisp-3

MY_V="v${PV}"

DESCRIPTION="Flexible bivalent streams for Common Lisp"
HOMEPAGE="http://weitz.de/flexi-streams/
		http://www.cliki.net/flexi-streams/"
SRC_URI="https://github.com/edicl/${PN}/archive/${MY_V}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="!dev-lisp/cl-${PN}
		>=dev-lisp/trivial-gray-streams-20060925"

src_install() {
	common-lisp-install-sources *.lisp
	common-lisp-install-asdf
	dohtml doc/index.html
}
