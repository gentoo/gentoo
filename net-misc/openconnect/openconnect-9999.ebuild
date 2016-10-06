# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit eutils java-pkg-opt-2 linux-info python-any-r1 readme.gentoo-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://git.infradead.org/users/dwmw2/${PN}.git"
	inherit git-r3 autotools
else
	ARCHIVE_URI="ftp://ftp.infradead.org/pub/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi
VPNC_VER=20160829
SRC_URI="${ARCHIVE_URI}
	ftp://ftp.infradead.org/pub/vpnc-scripts/vpnc-scripts-${VPNC_VER}.tar.gz"

DESCRIPTION="Free client for Cisco AnyConnect SSL VPN software"
HOMEPAGE="http://www.infradead.org/openconnect.html"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5"
IUSE="doc +gnutls gssapi java libproxy lz4 nls smartcard static-libs stoken"

DEPEND="dev-libs/libxml2
	sys-libs/zlib
	!gnutls? (
		>=dev-libs/openssl-1.0.1h:0[static-libs?]
	)
	gnutls? (
		>=net-libs/gnutls-3:0=[static-libs?] dev-libs/nettle
		app-misc/ca-certificates
	)
	gssapi? ( virtual/krb5 )
	libproxy? ( net-libs/libproxy )
	lz4? ( app-arch/lz4:= )
	nls? ( virtual/libintl )
	smartcard? ( sys-apps/pcsc-lite:0= )
	stoken? ( app-crypt/stoken )"
RDEPEND="${DEPEND}
	sys-apps/iproute2
	!<sys-apps/openrc-0.13"
DEPEND="${DEPEND}
	virtual/pkgconfig
	doc? ( ${PYTHON_DEPS} sys-apps/groff )
	java? ( >=virtual/jdk-1.6 )
	nls? ( sys-devel/gettext )"

CONFIG_CHECK="~TUN"

pkg_pretend() {
	check_extra_config
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
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
	if [[ ${LINGUAS+set} == set ]]; then
		strip-linguas -u po
		echo "${LINGUAS}" > po/LINGUAS || die
	fi

	if use doc; then
		python_setup
	else
		# If the python cannot be found, the docs will not build
		sed -e 's#"${ac_cv_path_PYTHON}"#""#' -i configure || die
	fi

	# liboath not in portage
	econf \
		--with-vpnc-script="${EPREFIX}/etc/openconnect/openconnect.sh" \
		$(use_enable static-libs static) \
		$(use_enable nls ) \
		$(use_with !gnutls openssl) \
		$(use_with gnutls ) \
		$(use_with libproxy) \
		$(use_with lz4) \
		$(use_with gssapi) \
		$(use_with smartcard libpcsclite) \
		$(use_with stoken) \
		$(use_with java)
}

DOC_CONTENTS="The init script for openconnect supports multiple vpn tunnels.

You need to create a symbolic link to /etc/init.d/openconnect in /etc/init.d
instead of calling it directly:

ln -s /etc/init.d/openconnect /etc/init.d/openconnect.vpn0

You can then start the vpn tunnel like this:

/etc/init.d/openconnect.vpn0 start

If you would like to run preup, postup, predown, and/or postdown scripts,
You need to create a directory in /etc/openconnect with the name of the vpn:

mkdir /etc/openconnect/vpn0

Then add executable shell files:

mkdir /etc/openconnect/vpn0
cd /etc/openconnect/vpn0
echo '#!/bin/sh' > preup.sh
cp preup.sh predown.sh
cp preup.sh postup.sh
cp preup.sh postdown.sh
chmod 755 /etc/openconnect/vpn0/*
"

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS TODO
	newinitd "${FILESDIR}"/openconnect.init.in-r4 openconnect
	dodir /etc/openconnect
	insinto /etc/openconnect
	newconfd "${FILESDIR}"/openconnect.conf.in openconnect
	exeinto /etc/openconnect
	newexe "${WORKDIR}"/vpnc-scripts-${VPNC_VER}/vpnc-script openconnect.sh
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openconnect.logrotate openconnect
	keepdir /var/log/openconnect

	# Remove useless .la files
	prune_libtool_files --all

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "You may want to consider installing the following optional packages."
		optfeature "resolvconf support" net-dns/openresolv
	fi
}
