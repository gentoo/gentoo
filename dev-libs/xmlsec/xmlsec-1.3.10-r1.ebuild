# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/alekseysanin.asc
inherit autotools verify-sig

DESCRIPTION="Command line tool for signing, verifying, encrypting and decrypting XML"
HOMEPAGE="https://www.aleksey.com/xmlsec/"
SRC_URI="
	https://www.aleksey.com/xmlsec/download/${PN}1-${PV}.tar.gz
	https://www.aleksey.com/xmlsec/download/older-releases/${PN}1-${PV}.tar.gz
	verify-sig? (
		https://www.aleksey.com/xmlsec/download/${PN}1-${PV}.sig
		https://www.aleksey.com/xmlsec/download/older-releases/${PN}1-${PV}.sig
	)
"
S="${WORKDIR}/${PN}1-${PV}"

LICENSE="MIT"
# configure.ac: "For simplicity we just bump current all the time and don't bother"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="doc gcrypt gnutls http nss +openssl static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( gnutls nss openssl )
"

RDEPEND="
	>=dev-libs/libxml2-2.9.13:=
	>=dev-libs/libxslt-1.1.35:=
	>=dev-libs/libltdl-1.0.0:=
	gcrypt? ( >=dev-libs/libgcrypt-1.4.0:= )
	gnutls? ( >=net-libs/gnutls-3.8.3:= )
	nss? (
		>=dev-libs/nspr-4.34.1:=
		>=dev-libs/nss-3.91:=
	)
	openssl? ( >=dev-libs/openssl-3.0.13:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		nss? (
			>=dev-libs/nss-3.91[utils]
		)
	)
	verify-sig? ( sec-keys/openpgp-keys-alekseysanin )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-optimisation.patch
)

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${PN}1-${PV}.{tar.gz,sig}
	fi
	default
}

src_prepare() {
	default

	eautoreconf

	# skip failing test (this is fixed in 1.3.11) - #972730
	sed -i '1842s/zyes/zskip/' tests/testDSig.sh || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc docs)
		$(use_enable http)
		$(use_enable static-libs static)
		$(use_with gcrypt)
		$(use_with gnutls)
		$(use_with nss nspr)
		$(use_with nss)
		$(use_with openssl)
		--disable-ftp
		--disable-werror
		--enable-concatkdf
		--enable-dh
		--enable-ec
		--enable-files
		--enable-mans
		--enable-pbkdf2
		--enable-pkgconfig
		--enable-sha3
	)

	# Bash because of bug #721128
	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_test() {
	# See https://github.com/lsh123/xmlsec/issues/280 for TZ=UTC
	TZ=UTC SHELL="${BROOT}"/bin/bash emake TMPFOLDER="${T}" -Onone check
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
