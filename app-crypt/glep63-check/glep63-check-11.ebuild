# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="GLEP 63 compliance checker for OpenPGP keys"
HOMEPAGE="https://github.com/projg2/glep63-check/"
SRC_URI="
	https://github.com/projg2/glep63-check/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86"

RDEPEND="
	app-crypt/gnupg
"
DEPEND="
	test? (
		>=app-crypt/gnupg-2.3.3
		sys-libs/libfaketime
	)
"

distutils_enable_tests unittest

src_test() {
	local -x GNUPGHOME=${T}/gnupg
	mkdir -p "${GNUPGHOME}" || die

	distutils-r1_src_test
}
