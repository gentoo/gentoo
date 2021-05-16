# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="OWASP ModSecurity Core Rule Set"
HOMEPAGE="https://coreruleset.org/"
SRC_URI="https://github.com/coreruleset/coreruleset/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=www-apache/mod_security-2.9.1"

S="${WORKDIR}/coreruleset-${PV}"

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
