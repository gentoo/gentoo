# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Command line tool for signing, verifying, encrypting and decrypting XML"
HOMEPAGE="https://www.aleksey.com/xmlsec"
SRC_URI="https://www.aleksey.com/xmlsec/download/${PN}1-${PV}.tar.gz"
S="${WORKDIR}/${PN}1-${PV}"

LICENSE="MIT"
# Upstream consider major version bumps to be changes in either X or Y in X.Y.Z
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv ~sparc x86"
IUSE="doc gcrypt gnutls http nss +openssl static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( gnutls nss openssl )
"

RDEPEND="
	>=dev-libs/libxml2-2.7.4
	>=dev-libs/libxslt-1.0.20
	dev-libs/libltdl
	gcrypt? ( >=dev-libs/libgcrypt-1.4.0:= )
	gnutls? ( >=net-libs/gnutls-3.6.13:= )
	nss? (
		>=dev-libs/nspr-4.4.1
		>=dev-libs/nss-3.9
	)
	openssl? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		nss? (
			>=dev-libs/nss-3.9[utils]
		)
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-optimisation.patch
	"${FILESDIR}"/${PN}-1.3.3-typo-fix.patch
	"${FILESDIR}"/${PN}-1.3.3-slibtool.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc docs)
		$(use_enable static-libs static)
		$(use_with gcrypt)
		$(use_with gnutls)
		$(use_with nss nspr)
		$(use_with nss)
		$(use_with openssl)

		--disable-werror
		--enable-mans
		--enable-pkgconfig

		--enable-concatkdf
		--enable-pbkdf2
		--enable-ec
		--enable-dh
		--enable-sha3

		--enable-files
		$(use_enable http)
		--disable-ftp
	)

	# Bash because of bug #721128
	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_test() {
	# See https://github.com/lsh123/xmlsec/issues/280 for TZ=UTC
	TZ=UTC SHELL="${BROOT}"/bin/bash emake TMPFOLDER="${T}" check
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
