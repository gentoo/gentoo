# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="UIOP is a portability layer spun off ASDF3"
HOMEPAGE="http://common-lisp.net/project/asdf/"
SRC_URI="http://common-lisp.net/project/asdf/archives/asdf-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="~dev-lisp/asdf-${PV}"

S="${WORKDIR}/${PN}"

src_install() {
	insinto /usr/share/common-lisp/source/${PN}
	doins -r contrib *.lisp ../version.lisp-expr uiop.asd asdf-driver.asd
	dodir /usr/share/common-lisp/systems
	dosym /usr/share/common-lisp/source/${PN}/uiop.asd /usr/share/common-lisp/systems/uiop.asd
	dosym /usr/share/common-lisp/source/${PN}/asdf-driver.asd /usr/share/common-lisp/systems/asdf-driver.asd
}
