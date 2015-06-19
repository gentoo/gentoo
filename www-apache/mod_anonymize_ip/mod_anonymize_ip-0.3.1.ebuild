# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_anonymize_ip/mod_anonymize_ip-0.3.1.ebuild,v 1.4 2014/08/10 20:13:39 slyfox Exp $

EAPI=4

inherit apache-module

GITHUB_AUTHOR="hollow"
GITHUB_PROJECT="mod_anonymize_ip"
GITHUB_COMMIT="c0d31d0"

DESCRIPTION="mod_anonymize_ip is a simple module for anonymizing the client IP address"
HOMEPAGE="http://github.com/hollow/mod_anonymize_ip"
SRC_URI="http://nodeload.github.com/${GITHUB_AUTHOR}/${GITHUB_PROJECT}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="ANONYMIZE_IP"

need_apache2_2

S="${WORKDIR}"/${GITHUB_AUTHOR}-${GITHUB_PROJECT}-${GITHUB_COMMIT}
