# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Core Rule Set for ModSecurity"
HOMEPAGE="
	https://www.owasp.org/index.php/Category:OWASP_ModSecurity_Core_Rule_Set_Project
	https://modsecurity.org/crs/
	https://coreruleset.org/"
SRC_URI="https://github.com/SpiderLabs/owasp-${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=www-apache/mod_security-2.9.1"

S="${WORKDIR}/owasp-${P}"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r rules

	dodoc CHANGES CONTRIBUTORS KNOWN_BUGS README.md crs-setup.conf.example \
		  id_renumbering/{IDNUMBERING,IdNumbering.csv}

	# I don't think it's worth pulling in apache-module.eclass just for
	# this path...
	insinto /etc/apache2/modules.d
	doins "${FILESDIR}/80_mod_security-crs.conf"
}

pkg_postinst() {
	einfo "The CRS configuration file has been installed to"
	einfo
	einfo "  ${ROOT}etc/apache2/modules.d/80_mod_security-crs.conf"
	einfo
	einfo "The CRS rules have been renumbered as of version 3.0.0."
	einfo "If your configuration refers to any rules based on their"
	einfo "number, then you will need to update your configuration"
	einfo "to reflect the new numbering system. You can find more"
	einfo "information in"
	einfo
	einfo "  ${ROOT}usr/share/doc/${PF}/IDNUMBERING"
	einfo
	einfo "and a CSV file containing the old -> new rule number"
	einfo "mapping was installed as"
	einfo
	einfo "  ${ROOT}usr/share/doc/${PF}/IdNumbering.csv"
	einfo
}
