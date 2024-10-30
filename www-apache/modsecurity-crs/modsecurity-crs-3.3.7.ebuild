# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="OWASP ModSecurity Core Rule Set"
HOMEPAGE="https://coreruleset.org/"
SRC_URI="https://github.com/coreruleset/coreruleset/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/coreruleset-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+apache2"

RDEPEND="apache2? ( >=www-apache/mod_security-2.9.6 )"

DOCS=( CHANGES.md CONTRIBUTORS.md crs-setup.conf.example KNOWN_BUGS README.md )

src_install() {
	insinto "/usr/share/${PN}"
	doins -r rules

	einstalldocs

	if use apache2; then
		# I don't think it's worth pulling in apache-module.eclass just for
		# this path...
		insinto /etc/apache2/modules.d
		doins "${FILESDIR}/80_mod_security-crs.conf"
	fi
}

pkg_postinst() {
	if use apache2; then
		einfo "The CRS configuration file has been installed to:"
		einfo "  ${ROOT}/etc/apache2/modules.d/80_mod_security-crs.conf"
	fi

	optfeature "apache-less installations, e.g. nginx" dev-libs/modsecurity
}
