# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Bash scripts to install tripwire and generate tripwire policy files"
HOMEPAGE="https://sourceforge.net/projects/mktwpol"
SRC_URI="mirror://sourceforge/mktwpol/${PF}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="app-admin/tripwire"

S=${WORKDIR}/${PF}

src_prepare() {
	default
	sed -i -e 's:/usr/local:/usr:' Makefile || die
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
	# ewarn message if a version change from 0.x.x
	if [[ "${REPLACING_VERSIONS:0:1}" == "0" ]] ; then
		ewarn
		ewarn "Mktwpol default policy-generating rules no longer sort by package."
		ewarn
		ewarn "   This change does not reduce the scope of system inspection!"
		ewarn "          It only affects the tripwire report format."
		ewarn
		ewarn "  The previous default reporting format is still available, at"
		ewarn "  /usr/share/doc/${PF}/mktwpol-gentoo-packages.rules*"
		ewarn
	fi
}
