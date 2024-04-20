# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module depend.apache

MY_PV=$(ver_rs 2 '')
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Bandwidth Management Module for Apache2"
HOMEPAGE="http://wp.ivn.cl/apache-bandwidth-mod/"
SRC_URI="http://legacy.ivn.cl/files/source/${MY_P}.tgz"

KEYWORDS="amd64 ppc x86"
LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="dev-build/libtool"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.2-apache24.patch
)

APACHE2_MOD_CONF="11_${PN}"
APACHE2_MOD_DEFINE="BW"

need_apache2

S="${WORKDIR}"

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}
