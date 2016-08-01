# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="HTML documentation for Python"
HOMEPAGE="https://www.python.org/doc/"
SRC_URI="https://www.python.org/ftp/python/doc/${PV}/python-${PV}-docs-html.tar.bz2"

LICENSE="PSF-2"
SLOT="2.7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

S="${WORKDIR}/python-${PV}-docs-html"

src_install() {
	rm -r _sources || die
	docinto html
	dodoc -r .

	echo "PYTHONDOCS_${SLOT//./_}=\"${EPREFIX}/usr/share/doc/${PF}/html/library\"" > "60python-docs-${SLOT}" || die
	doenvd "60python-docs-${SLOT}"
}
