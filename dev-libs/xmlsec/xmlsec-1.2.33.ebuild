# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command line tool for signing, verifying, encrypting and decrypting XML"
HOMEPAGE="https://www.aleksey.com/xmlsec"
SRC_URI="https://www.aleksey.com/xmlsec/download/${PN}1-${PV}.tar.gz"
S="${WORKDIR}/${PN}1-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc gcrypt gnutls nss +openssl static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( gcrypt gnutls nss openssl )
	gnutls? ( gcrypt )"

RDEPEND=">=dev-libs/libxml2-2.7.4:=
	>=dev-libs/libxslt-1.0.20:=
	dev-libs/libltdl
	gcrypt? ( >=dev-libs/libgcrypt-1.4.0:0= )
	gnutls? ( >=net-libs/gnutls-2.8.0:= )
	nss? (
		>=dev-libs/nspr-4.4.1:=
		>=dev-libs/nss-3.9:=
	)
	openssl? (
		dev-libs/openssl:0=
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	test? (
		nss? (
			>=dev-libs/nss-3.9[utils]
		)
	)"

src_configure() {
	# Bash because of bug #721128
	CONFIG_SHELL=${BASH} econf \
		$(use_enable doc docs) \
		$(use_enable static-libs static) \
		$(use_with gcrypt) \
		$(use_with gnutls) \
		$(use_with nss nspr) \
		$(use_with nss) \
		$(use_with openssl) \
		--enable-mans \
		--enable-pkgconfig
}

src_test() {
	# See https://github.com/lsh123/xmlsec/issues/280 for TZ=UTC
	TZ=UTC SHELL=${BASH} emake TMPFOLDER="${T}" check
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
