# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit common-lisp-3

DESCRIPTION="UIOP is a portability layer spun off ASDF3"
HOMEPAGE="http://common-lisp.net/project/asdf/"
SRC_URI="http://common-lisp.net/project/asdf/archives/asdf-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""

RDEPEND="~dev-lisp/asdf-${PV}"

S="${WORKDIR}/asdf-${PV}/${PN}"

src_install() {
	insinto "${CLSOURCEROOT}/${PN}"
	doins -r contrib *.lisp ../version.lisp-expr "${PN}.asd" asdf-driver.asd
	dodir "${CLSYSTEMROOT}"
	dosym "${CLSOURCEROOT}/${PN}/${PN}.asd" "${CLSYSTEMROOT}/${PN}.asd"
	dosym "${CLSOURCEROOT}/${PN}/asdf-driver.asd" "${CLSYSTEMROOT}/asdf-driver.asd"
}
