# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/tahoe-lafs/tahoe-lafs-1.10.0-r2.ebuild,v 1.8 2015/04/08 18:16:09 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

MY_PN="allmydata-tahoe"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Secure, decentralized, data store"
HOMEPAGE="http://tahoe-lafs.org/trac/tahoe-lafs"
SRC_URI="http://tahoe-lafs.org/source/tahoe-lafs/releases/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="
	>=dev-python/foolscap-0.6.1[${PYTHON_USEDEP}]
	dev-python/nevow[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/pycryptopp[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyutil[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-9.0.0-r1[${PYTHON_USEDEP}]
	dev-python/zbase32[${PYTHON_USEDEP}]
	dev-python/zfec[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-{setup,ifconfig}.patch )

src_prepare() {
	rm -r setuptools* setup.cfg || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	use doc && dodoc -r docs/*
}

pkg_postinst() {
	elog
	elog "optional dependencies:"
	elog "  dev-python/twisted-conch (for sftp access)"
	elog
}
