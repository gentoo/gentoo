# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Simple PKCS11 provider for TPM chips"
HOMEPAGE="https://github.com/ThomasHabets/simple-tpm-pk11"

LICENSE="Apache-2.0"
SLOT="0"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/ThomasHabets/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ThomasHabets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

RESTRICT="test" # needs to communicate with the TPM and gtest is all broken

DEPEND="app-crypt/tpm-tools[pkcs11]
	dev-libs/opencryptoki[tpm]
	app-crypt/trousers
	dev-libs/openssl:0=
	"
RDEPEND="${DEPEND}
	net-misc/openssh[-X509]"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
