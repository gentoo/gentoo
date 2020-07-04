# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="A PKCS#11 interface for TPM2 hardware"
HOMEPAGE="https://tpm2-software.github.io/"
SRC_URI="https://github.com/tpm2-software/tpm2-pkcs11/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

# Test requires the IBM TPM simulator that's not in portage
RESTRICT="test"

RDEPEND="app-crypt/p11-kit
	app-crypt/tpm2-abrmd
	app-crypt/tpm2-tss
	dev-db/sqlite:3
	dev-libs/openssl
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"
BDEPEND="sys-devel/autoconf-archive
	virtual/pkgconfig"

src_configure() {
	default
}

src_compile() {
	default
	cd "${S}/tools" || die
	BUILD_DIR="${S}/tools" python_foreach_impl distutils-r1_python_compile
}

src_install() {
	default
	cd "${S}/tools" || die
	BUILD_DIR="${S}/tools" python_foreach_impl distutils-r1_python_install
	dobin "${S}/tools/tpm2_ptool"
}
