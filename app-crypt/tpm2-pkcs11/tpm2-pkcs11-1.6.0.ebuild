# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_REQ_USE="sqlite"

inherit autotools distutils-r1

DESCRIPTION="A PKCS#11 interface for TPM2 hardware"
HOMEPAGE="https://tpm2-software.github.io/"
SRC_URI="https://github.com/tpm2-software/tpm2-pkcs11/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="fapi"

# python-pkcs11 is required but not in Portage. python-pkcs11 in turn requires
# aenum which is ALSO not in portage. Futhermore, aenum has a dead homepage.
RESTRICT="test"

RDEPEND="app-crypt/p11-kit
	app-crypt/tpm2-abrmd
	app-crypt/tpm2-tools[fapi?]
	!fapi? ( app-crypt/tpm2-tss )
	fapi? ( >=app-crypt/tpm2-tss-3.0.1[fapi] )
	dev-db/sqlite:3
	dev-libs/openssl:=
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}] "

DEPEND="${RDEPEND}"
BDEPEND="sys-devel/autoconf-archive
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.2-Remove-WError.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable fapi)
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
	find "${ED}" -name '*.la' -delete || die
}
