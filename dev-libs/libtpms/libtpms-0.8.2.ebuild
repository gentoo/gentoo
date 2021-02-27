# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library providing software emultion of a TPM"
HOMEPAGE="https://github.com/stefanberger/libtpms"
SRC_URI="https://github.com/stefanberger/libtpms/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl"

DEPEND=" !libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.8.0-Remove-WError.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--with-openssl \
		--with-tpm2
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "Versions of libtpms prior to 0.8.0 generate weaker than expected TPM 2.0 RSA"
	elog "keys due to a flawed key creation algorithm. Because fixing this would render"
	elog "existing sealed data inaccessible, to use the corrected algorithm, the old"
	elog "TPM state file must be deleted and a new TPM state file created. Data still"
	elog "sealed using the old state file will be permanently inaccessible. For the"
	elog "details see https://github.com/stefanberger/libtpms/issues/183"
}
