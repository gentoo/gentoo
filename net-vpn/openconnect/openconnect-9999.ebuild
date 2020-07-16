# Copyright 2011-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )
PYTHON_REQ_USE="xml"

inherit linux-info python-any-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/openconnect/openconnect.git"
	inherit git-r3 autotools
else
	ARCHIVE_URI="ftp://ftp.infradead.org/pub/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64"
fi
VPNC_VER=20200226
SRC_URI="${ARCHIVE_URI}
	ftp://ftp.infradead.org/pub/vpnc-scripts/vpnc-scripts-${VPNC_VER}.tar.gz"

DESCRIPTION="Free client for Cisco AnyConnect SSL VPN software"
HOMEPAGE="http://www.infradead.org/openconnect.html"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5"
IUSE="doc +gnutls gssapi libproxy lz4 nls smartcard static-libs stoken test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libxml2
	sys-libs/zlib
	!gnutls? (
		>=dev-libs/openssl-1.0.1h:0=[static-libs?]
	)
	gnutls? (
		app-crypt/trousers
		app-misc/ca-certificates
		dev-libs/nettle
		>=net-libs/gnutls-3.6.13:0=[static-libs?]
	)
	gssapi? ( virtual/krb5 )
	libproxy? ( net-libs/libproxy )
	lz4? ( app-arch/lz4:= )
	nls? ( virtual/libintl )
	smartcard? ( sys-apps/pcsc-lite:0= )
	stoken? ( app-crypt/stoken )
"
RDEPEND="${DEPEND}
	sys-apps/iproute2
"
BDEPEND="
	virtual/pkgconfig
	doc? ( ${PYTHON_DEPS} sys-apps/groff )
	nls? ( sys-devel/gettext )
	test? (
		net-libs/socket_wrapper
		net-vpn/ocserv
		sys-libs/uid_wrapper
	)
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
		$(use_enable static-libs static)
		$(use_with !gnutls openssl)
		$(use_with gnutls)
		$(use_with libproxy)
		$(use_with lz4)
		$(use_with gssapi)
		$(use_with smartcard libpcsclite)
		$(use_with stoken)
		--with-vpnc-script="${EPREFIX}/etc/openconnect/openconnect.sh"
		--without-java
	)

	econf "${myconf[@]}"
}

src_test() {
	local charset
	for charset in UTF-8 ISO8859-2; do
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

	dodoc "${FILESDIR}"/README.OpenRC.txt

	newinitd "${FILESDIR}"/openconnect.init.in-r4 openconnect
	insinto /etc/openconnect

	newconfd "${FILESDIR}"/openconnect.conf.in openconnect

	exeinto /etc/openconnect
	newexe "${WORKDIR}"/vpnc-scripts-${VPNC_VER}/vpnc-script openconnect.sh

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openconnect.logrotate openconnect

	keepdir /var/log/openconnect
}
