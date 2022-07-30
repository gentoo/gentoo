# Copyright 2011-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml"

inherit linux-info python-any-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/openconnect/openconnect.git"
	inherit git-r3 autotools
else
	SRC_URI="ftp://ftp.infradead.org/pub/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
fi

DESCRIPTION="Free client for Cisco AnyConnect SSL VPN software"
HOMEPAGE="https://www.infradead.org/openconnect/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5"
IUSE="doc +gnutls gssapi libproxy lz4 nls pskc selinux smartcard stoken test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/libxml2
	sys-libs/zlib
	app-crypt/p11-kit
	!gnutls? (
		>=dev-libs/openssl-1.0.1h:0=
		dev-libs/libp11
	)
	gnutls? (
		app-crypt/trousers
		app-misc/ca-certificates
		dev-libs/nettle
		>=net-libs/gnutls-3.6.13:0=
		dev-libs/libtasn1:0=
		app-crypt/tpm2-tss:=
	)
	gssapi? ( virtual/krb5 )
	libproxy? ( net-libs/libproxy )
	lz4? ( app-arch/lz4:= )
	nls? ( virtual/libintl )
	pskc? ( sys-auth/oath-toolkit[pskc] )
	smartcard? ( sys-apps/pcsc-lite:0= )
	stoken? ( app-crypt/stoken )
"
DEPEND="${COMMON_DEPEND}
	test? (
		net-libs/socket_wrapper
		sys-libs/uid_wrapper
		!gnutls? ( dev-libs/openssl:0[weak-ssl-ciphers(-)] )
	)
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/iproute2
	>=net-vpn/vpnc-scripts-20210402-r1
	selinux? ( sec-policy/selinux-vpn )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( ${PYTHON_DEPS} sys-apps/groff )
	nls? ( sys-devel/gettext )
	test? ( net-vpn/ocserv )
"

CONFIG_CHECK="~TUN"

pkg_pretend() {
	check_extra_config
}

pkg_setup() {
	:
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi
	default
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/8.20-rsa-securid.patch"
		"${FILESDIR}/8.20-insecure-crypto.patch"
	)
	default
	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	fi
}

src_configure() {
	if use doc; then
		python_setup
	else
		export ac_cv_path_PYTHON=
	fi

	# Used by tests if userpriv is disabled
	addwrite /run/netns

	local myconf=(
		--disable-dsa-tests
		$(use_enable nls)
		--disable-static
		$(use_with !gnutls openssl)
		$(use_with gnutls)
		$(use_with libproxy)
		$(use_with lz4)
		$(use_with gssapi)
		$(use_with pskc libpskc)
		$(use_with smartcard libpcsclite)
		$(use_with stoken)
		--with-vpnc-script="${EPREFIX}/etc/vpnc/vpnc-script"
		--without-java
	)

	econf "${myconf[@]}"
}

src_test() {
	local charset
	for charset in UTF-8 ISO-8859-2; do
		if [[ $(LC_ALL=cs_CZ.${charset} locale charmap 2>/dev/null) != ${charset} ]]; then
			# If we don't have valid cs_CZ locale data, auth-nonascii will fail.
			# Force a test skip by exiting with status 77.
			sed -i -e '2i exit 77' tests/auth-nonascii || die
			break
		fi
	done
	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	dodoc "${FILESDIR}"/README.OpenRC

	newconfd "${FILESDIR}"/openconnect.confd openconnect
	newinitd "${FILESDIR}"/openconnect.initd openconnect

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openconnect.logrotate openconnect

	keepdir /var/log/openconnect
}
