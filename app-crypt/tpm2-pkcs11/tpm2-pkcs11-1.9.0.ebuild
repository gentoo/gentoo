# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1

DESCRIPTION="A PKCS#11 interface for TPM2 hardware"
HOMEPAGE="https://tpm2-software.github.io/"
SRC_URI="https://github.com/tpm2-software/tpm2-pkcs11/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="fapi test"
REQUIRED_USE="( ${PYTHON_REQUIRED_USE} )"

# Units tests only for now
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	app-crypt/p11-kit
	app-crypt/tpm2-abrmd
	app-crypt/tpm2-tools[fapi?]
	!fapi? ( app-crypt/tpm2-tss:= )
	fapi? ( >=app-crypt/tpm2-tss-3.0.1:=[fapi] )
	dev-db/sqlite:3
	dev-libs/libyaml
	dev-libs/openssl:=
	$(python_gen_cond_dep '
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tpm2-pytss[${PYTHON_USEDEP}]
	')
"

DEPEND="test? ( dev-util/cmocka )
	${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	sys-devel/autoconf-archive
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable fapi) \
		$(use_enable test unit)
}

src_install() {
	default
	python_domodule tools/tpm2_pkcs11
	python_newscript tools/tpm2_ptool.py tpm2_ptool
	find "${ED}" -name '*.la' -delete || die
}
