# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="HTML documentation for Python"
HOMEPAGE="https://www.python.org/doc/"
SRC_URI="https://www.python.org/ftp/python/doc/${PV}/python-${PV}-docs-html.tar.bz2"
S="${WORKDIR}/python-${PV}-docs-html"

LICENSE="PSF-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sparc ~x86"

src_install() {
	rm -r _sources || die
	docinto html
	dodoc -r .

	newenvd - 60python-docs-${SLOT} <<-EOF
		PYTHONDOCS_${SLOT//./_}="${EPREFIX}/usr/share/doc/${PF}/html/library"
	EOF
}
