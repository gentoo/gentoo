# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="A simple Identi.ca client with a curses-based UI"
HOMEPAGE="http://identicurse.net"
SRC_URI="http://identicurse.net/release/${MY_PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="dev-python/oauth"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-gzipped_readme.patch \
		"${FILESDIR}"/${PV}-config_json_path.patch
	rm -rf src/oauth #405735
	distutils_src_prepare
}
