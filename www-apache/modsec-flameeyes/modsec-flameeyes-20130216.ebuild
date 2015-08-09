# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo

GITHUB_USER=Flameeyes
GITHUB_PROJECT=${PN}

EGIT_REPO_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}.git"

DESCRIPTION="Flameeyes's Ruleset for ModSecurity"
HOMEPAGE="http://www.flameeyes.eu/projects/modsec"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=www-apache/mod_security-2.5.1"
DEPEND=""

RULESDIR=/etc/modsecurity/flameeyes

DOC_CONTENTS="To enable the ruleset, define MODSEC_FLAMEEYES in
/etc/conf.d/apache2.

If you do not use www-apache/modsecurity-crs you want also to uncomment
the init configuration file in /etc/apache2/modules/81_${PN}.conf."

src_install() {
	insinto "${RULESDIR}"
	doins -r rules optional

	dodoc README.md

	cat - > "${T}/81_${PN}.conf" <<EOF
<IfDefine MODSEC_FLAMEEYES>

# Uncomment this if you don't use the CRS
# Include /etc/modsecurity/flameeyes/optional/flameeyes_init.conf

Include /etc/modsecurity/flameeyes/rules/*.conf

# -*- apache -*-
# vim: ts=4 filetype=apache

EOF

	insinto /etc/apache2/modules.d/
	doins "${T}/81_${PN}.conf"

	readme.gentoo_create_doc
}
