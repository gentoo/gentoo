# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="OWASP ModSecurity Core Rule Set"
HOMEPAGE="https://coreruleset.org/"
SRC_URI="https://github.com/coreruleset/coreruleset/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="|| ( >=www-apache/mod_security-2.9.6 >=dev-libs/modsecurity-3.0.8 )"

S="${WORKDIR}/coreruleset-${PV}"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r rules util

	dodoc CHANGES CONTRIBUTING.md CONTRIBUTORS.md KNOWN_BUGS README.md crs-setup.conf.example

	if has_version www-servers/apache; then
		# I don't think it's worth pulling in apache-module.eclass just for
		# this path...
		insinto /etc/apache2/modules.d
		doins "${FILESDIR}/80_mod_security-crs.conf"
	fi

	if has_version www-servers/nginx; then
		insinto "/etc/modsecurity"
		doins -r crs-setup.conf.example
	fi
}

pkg_postinst() {
	if has_version www-servers/apache; then
		einfo "The CRS configuration file has been installed to:"
		einfo "  ${ROOT}/etc/apache2/modules.d/80_mod_security-crs.conf"
	fi

	einfo
	einfo "The CRS rules have been renumbered as of version 3.0.0."
	einfo "If your configuration refers to any rules based on their"
	einfo "number, then you will need to update your configuration"
	einfo "to reflect the new numbering system. You can find more"
	einfo "information in"
	einfo
	einfo "  ${ROOT}/usr/share/doc/${PF}/IDNUMBERING"
	einfo
	einfo "and a CSV file containing the old -> new rule number"
	einfo "mapping was installed as"
	einfo
	einfo "  ${ROOT}/usr/share/doc/${PF}/IdNumbering.csv"
	einfo
}
