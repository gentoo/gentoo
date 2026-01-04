# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 edo pypi

DESCRIPTION="PKCS#11/Cryptoki support for Python"
HOMEPAGE="
		https://github.com/pyauth/python-pkcs11
		https://pypi.org/project/python-pkcs11
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/asn1crypto[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
		test? (
				dev-libs/openssl
				dev-libs/softhsm
				dev-python/cryptography[${PYTHON_USEDEP}]
				dev-python/parameterized[${PYTHON_USEDEP}]
		)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

PATCHES=( "${FILESDIR}/${PN}-0.9.3-refactor-under-src.patch" )

src_test() {
	local -x PKCS11_MODULE="${BROOT}/usr/$(get_libdir)/softhsm/libsofthsm2.so"
	local -x PKCS11_TOKEN_LABEL="TEST"
	local -x PKCS11_TOKEN_PIN="1234"
	local -x PKCS11_TOKEN_SO_PIN="5678"

	mkdir -p "${HOME}/.config/softhsm2" || die
	cat > "${HOME}/.config/softhsm2/softhsm2.conf" <<- EOF || die "Failed to create config"
		directories.tokendir = ${T}
		objectstore.backend = file
	EOF

	edo softhsm2-util --init-token --free \
		--label ${PKCS11_TOKEN_LABEL} \
		--pin ${PKCS11_TOKEN_PIN} \
		--so-pin ${PKCS11_TOKEN_SO_PIN}

	distutils-r1_src_test
}
