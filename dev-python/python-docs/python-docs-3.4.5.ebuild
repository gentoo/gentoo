# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver

DESCRIPTION="HTML documentation for Python"
HOMEPAGE="https://www.python.org/doc/"
SRC_URI="https://www.python.org/ftp/python/doc/${PV}/python-${PV}-docs-html.tar.bz2"

LICENSE="PSF-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S="${WORKDIR}/python-${PV}-docs-html"

src_install() {
	rm -r _sources || die
	docinto html
	dodoc -r .

	echo "PYTHONDOCS_${SLOT//./_}=\"${EPREFIX}/usr/share/doc/${PF}/html/library\"" > "60python-docs-${SLOT}" || die
	doenvd "60python-docs-${SLOT}"
}
