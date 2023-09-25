# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bash scripts to install tripwire and generate tripwire policy files"
HOMEPAGE="https://sourceforge.net/projects/mktwpol"
SRC_URI="mirror://sourceforge/mktwpol/${P}.tar.gz"
S=${WORKDIR}/${P}

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="app-admin/tripwire"

src_prepare() {
	default
	sed -i \
		-e 's:/usr/local:/usr:' \
		-e "s|^docdir.*|docdir = \"${EPREFIX}/usr/share/doc/${PF}\"|g" \
		Makefile || die
}

pkg_preinst() {
	# one elog message for new/first installation
	# different elog message when updating
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog
		elog "To facilitate a new installation and setup of tripwire:"
		elog " - Run: \`twsetup.sh\`"
		elog
		elog "To update tripwire database as packages are added or deleted:"
		elog " - Run: \`mktwpol.sh -u\`"
		elog
		elog "Mktwpol is packaged with multiple policy-generating rules files."
		elog "A default \"rules file\" is installed in /etc/tripwire"
		elog "Alternatives are available in /usr/share/doc/${PF}"
		elog
		elog "mktwpol.sh uses the policy-generating rules file with the"
		elog "most recent date.  To use an alternative \"rules file\","
		elog "copy it from /usr/share/doc/${PF} to /etc/tripwire,"
		elog " uncompress it, and \`touch\` it."
		elog
		elog "Read /usr/share/doc/${PF}/README for more tips."
		elog
	else
		elog
		elog "Version bump: mktwpol policy-generating rules have changed."
		elog "Run \`mktwpol.sh -u\` to update tripwire policy and database."
		elog
		elog "Alternative policy-generating rules are in /usr/share/doc/${PF}"
		elog "To use an alternative policy-generating rules file,"
		elog "copy it to /etc/tripwire, uncompress and \`touch\` it."
		elog
	fi
}
