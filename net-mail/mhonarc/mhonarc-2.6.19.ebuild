# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Perl Mail-to-HTML Converter"
HOMEPAGE="https://www.mhonarc.org/"
SRC_URI="https://www.mhonarc.org/release/MHonArc/tar/MHonArc-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
# Warrants IUSE examples, and here it is + ? IUSE doc; see also extras folder with html docs
IUSE="examples"

S="${WORKDIR}/${P/mhonarc/MHonArc}"
mydoc="README.txt"

# From upstream bugtracker: https://savannah.nongnu.org/bugs/?49997
PATCHES=( "${FILESDIR}/mhonarc-fix-perl-defined-bugs.diff" )

src_install() {
	sed -e "s|-prefix |-docpath '${D}/usr/share/doc/${PF}/html' -prefix '${D}'|g" -i Makefile || die 'sed on Makefile failed'
	sed -e "s|installsitelib|installvendorlib|g" -i install.me || die 'sed on install.me failed'
	perl-module_src_install
	if use examples; then
		docompress -x usr/share/doc/${PF}/examples
		insinto usr/share/doc/${PF}/
		doins -r examples/
	fi
}
