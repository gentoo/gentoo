# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="nss-altfiles"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="NSS module to read passwd/group files from CoreOS /usr location"
HOMEPAGE="https://github.com/coreos/nss-altfiles"
SRC_URI="https://github.com/coreos/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""

src_configure() {
	: # Don't bother with the custom configure script.
}

src_compile() {
	tc-export CC
	emake DATADIR=/usr/share/baselayout MODULE_NAME=usrfiles
}

src_install() {
	dolib.so libnss_usrfiles.so.2
}
