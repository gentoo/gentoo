# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/simple-tpm-pk11/simple-tpm-pk11-0.03.ebuild,v 1.1 2015/05/19 20:49:24 perfinion Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="Simple PKCS11 provider for TPM chips"
HOMEPAGE="https://github.com/ThomasHabets/simple-tpm-pk11"

LICENSE="Apache-2.0"
SLOT="0"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/ThomasHabets/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/ThomasHabets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

IUSE=""

DEPEND="app-crypt/tpm-tools[pkcs11]
	dev-libs/opencryptoki[tpm]
	app-crypt/trousers
	dev-libs/openssl:0="
RDEPEND="${DEPEND}
	net-misc/openssh[-X509]"

src_prepare() {
	epatch_user
	eautoreconf
}
