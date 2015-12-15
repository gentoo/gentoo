# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit common-lisp-3

MY_PV=${PV:0:4}-${PV:4:2}-${PV:6:2}
MY_P=${PN}-${MY_PV}

DESCRIPTION="A thin compatibility layer between Gray Stream Common Lisp implementations"
HOMEPAGE="https://common-lisp.net/project/trivial-gray-streams/"
SRC_URI="http://common-lisp.net/project/cl-plus-ssl/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="!dev-lisp/cl-${PN}"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	rm "${S}"/Makefile
}
