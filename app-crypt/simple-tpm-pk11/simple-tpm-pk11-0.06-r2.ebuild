# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/ThomasHabets/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ThomasHabets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Simple PKCS11 provider for TPM chips"
HOMEPAGE="https://github.com/ThomasHabets/simple-tpm-pk11"

LICENSE="Apache-2.0"
SLOT="0"
RESTRICT="test" # needs to communicate with the TPM and gtest is all broken

DEPEND="
	app-crypt/tpm-tools[pkcs11]
	app-crypt/trousers
	dev-libs/opencryptoki[tpm]
	dev-libs/openssl:=
"
RDEPEND="${DEPEND}
	|| (
		>=net-misc/openssh-9.3_p1-r1
		>=net-misc/openssh-contrib-9.3_p1[-X509]
	)
"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
