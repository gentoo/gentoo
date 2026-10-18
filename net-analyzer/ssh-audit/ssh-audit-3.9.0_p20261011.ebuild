# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..15} )

inherit distutils-r1

DESCRIPTION="SSH server auditing (banner, key exchange, encryption, mac, compression, etc)"
HOMEPAGE="https://github.com/jtesta/ssh-audit"
COMMIT="5db94b525290fac88faec4e91f4f83e6035f6b64"
SRC_URI="https://github.com/jtesta/ssh-audit/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="test"

PATCHES=(
	"${FILESDIR}/${PN}-3.9.0_p20261011_fix_dropbear_kexguess2.patch"
	"${FILESDIR}/${PN}-3.9.0_p20261011_add_ssh-mldsa44-ed25519.patch"
	"${FILESDIR}/${PN}-3.9.0_p20261011_add_mlkem768x25519-sha256_and_sntrup761x25519-sha512.patch"
)

# Tests require prospector which is not packaged
RESTRICT="test"

src_install() {
	distutils-r1_src_install

	doman ssh-audit.1
}
