# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit apache-module

GITHUB_AUTHOR="hollow"
GITHUB_PROJECT="mod_common_redirect"
GITHUB_COMMIT="595a370"

DESCRIPTION="mod_common_redirect implements common redirects without mod_rewrite overhead"
HOMEPAGE="https://github.com/hollow/mod_common_redirect"
SRC_URI="https://nodeload.github.com/${GITHUB_AUTHOR}/${GITHUB_PROJECT}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="COMMON_REDIRECT"

need_apache2

S="${WORKDIR}"/${GITHUB_AUTHOR}-${GITHUB_PROJECT}-${GITHUB_COMMIT}
