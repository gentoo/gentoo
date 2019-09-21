# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Core Rule Set for ModSecurity"
HOMEPAGE="
	https://www.owasp.org/index.php/Category:OWASP_ModSecurity_Core_Rule_Set_Project
	https://modsecurity.org/crs/
	https://coreruleset.org/"
SRC_URI="https://github.com/SpiderLabs/owasp-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=www-apache/mod_security-2.9.1"

S="${WORKDIR}/owasp-${P}"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r rules

	dodoc CHANGES CONTRIBUTORS.md KNOWN_BUGS README.md crs-setup.conf.example

	# I don't think it's worth pulling in apache-module.eclass just for
	# this path...
	insinto /etc/apache2/modules.d
	doins "${FILESDIR}/80_mod_security-crs.conf"
}

pkg_postinst() {
	einfo "The CRS configuration file has been installed to:"
	einfo "  ${ROOT}/etc/apache2/modules.d/80_mod_security-crs.conf"
}
