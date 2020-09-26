# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit apache-module

GITHUB_AUTHOR="hollow"
GITHUB_PROJECT="mod_common_redirect"
GITHUB_COMMIT="595a370"
DESCRIPTION="mod_common_redirect implements common redirects without mod_rewrite overhead"
HOMEPAGE="https://github.com/hollow/mod_common_redirect"
SRC_URI="https://nodeload.github.com/${GITHUB_AUTHOR}/${GITHUB_PROJECT}/tarball/v${PV} -> ${P}.tar.gz"
S="${WORKDIR}"/${GITHUB_AUTHOR}-${GITHUB_PROJECT}-${GITHUB_COMMIT}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

need_apache2

src_install() {
	APACHE2_MOD_CONF="20_${PN}"
	APACHE2_MOD_DEFINE="COMMON_REDIRECT"
	APACHE_MODULESDIR="/usr/$(get_libdir)/apache2/modules"
	apache-module_src_install
}
