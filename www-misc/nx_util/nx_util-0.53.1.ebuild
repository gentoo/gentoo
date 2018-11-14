# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1 versionator

MY_PV="$(replace_version_separator 2 '-')"

DESCRIPTION="Whitelist & Reports generation for Naxsi (Web App Firewall module for Nginx)"
HOMEPAGE="https://github.com/nbs-system/naxsi"
# keep the name in sync with what's in the nginx ebuild to avoid duplication
SRC_URI="https://github.com/nbs-system/naxsi/archive/${MY_PV}.tar.gz -> ngx_http_naxsi-${MY_PV}.tar.gz"

LICENSE="GPL-2+ Apache-2.0 CC-BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="www-servers/nginx[nginx_modules_http_naxsi]"

PATCHES=( "${FILESDIR}/0.52.1-fix-install-paths.patch" )

S="${WORKDIR}/naxsi-${MY_PV}/nx_util"

src_prepare() {
	distutils-r1_src_prepare
	mv nx_util{.py,} || die "renaming script failed"
}
