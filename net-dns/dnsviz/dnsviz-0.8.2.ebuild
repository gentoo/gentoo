# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1 eutils

DESCRIPTION="Tool suite for analysis and visualization of DNS and DNSSEC"
HOMEPAGE="https://dnsviz.net/"
SRC_URI="https://github.com/dnsviz/dnsviz/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/libnacl[${PYTHON_USEDEP}]
	>=dev-python/m2crypto-0.31.0[${PYTHON_USEDEP}]
	>=dev-python/pygraphviz-1.3.1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="
	${DEPEND}"

python_prepare_all() {
	# Fix the ebuild to use correct FHS/Gentoo policy paths for 0.8.2
	sed -i "s*share/doc/dnsviz*share/doc/dnsviz-${PV}*g" "${S}"/setup.py || die

	distutils-r1_python_prepare_all
}

pkg_postinst() {
	elog "Support for extra feature can be get from:"
	optfeature "Support for pre-deployment testing" net-dns/bind

	# Warn about extra requirements for >=OpenSSL 1.1.0
	if has_version '=dev-libs/openssl-1.1*'; then
	   echo
	   ewarn "With OpenSSL version 1.1.0 and later,the OpenSSL GOST Engine"
	   ewarn "is necessary to validate DNSSEC signatures with algorithm 12"
	   ewarn "(GOST R 34.10-2001) and digests of type 3 (GOST R 34.11-94)"
	   ewarn "OpenSSL GOST Engine can be get from --> dev-libs/gost-engine"
	fi
}
