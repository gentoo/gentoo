# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Bash scripts to install tripwire and generate tripwire policy files"
HOMEPAGE="https://sourceforge.net/projects/mktwpol"
SRC_URI="mirror://sourceforge/mktwpol/${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="app-admin/tripwire"

src_prepare() {
	default
	sed -i -e 's|/usr/local|/usr|' Makefile || die
}

pkg_postinst() {
	elog
	elog "Installation and setup of tripwire ..."
	elog " - Run: \`twsetup.sh\`"
	elog
	elog "Maintenance of tripwire as packages are added and/or deleted ..."
	elog " - Run: \`mktwpol.sh -u\` to update tripwire policy and database"
	elog
	elog "Mktwpol is packaged with multiple policy-rules-generating files."
	elog "The default \"rules file\" is installed in /etc/tripwire"
	elog "Alternatives are installed in /usr/share/doc/${P}"
	elog "To use an alternative \"rules file\" ..."
	elog "copy it to /etc/tripwire, uncompress it, and \`touch\` it ..."
	elog
	elog "\`cp /usr/share/doc/${P}/mktwpol*.rules.bz2 /etc/tripwire\`"
	elog "\`bunzip2 /etc/tripwire/mktwpol*.rules.bz2\`"
	elog
	elog "mktwpol.sh uses the rules file with the most recent date."
	elog "Use \`touch\` to choose between multiple rules files."
	elog
}
