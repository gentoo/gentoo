# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library providing software emultion of a TPM"
HOMEPAGE="https://github.com/stefanberger/libtpms"
SRC_URI="https://github.com/stefanberger/libtpms/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
	  --with-openssl \
	  --with-tpm2
}
