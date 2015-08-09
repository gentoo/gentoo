# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit eutils java-pkg-opt-2 linux-info python-any-r1 readme.gentoo

DESCRIPTION="Free client for Cisco AnyConnect SSL VPN software"
HOMEPAGE="http://www.infradead.org/openconnect.html"
VPNC_VER=20140806
SRC_URI="ftp://ftp.infradead.org/pub/${PN}/${P}.tar.gz
	ftp://ftp.infradead.org/pub/vpnc-scripts/vpnc-scripts-${VPNC_VER}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc +gnutls gssapi java libproxy nls static-libs"
ILINGUAS="ar cs de el en_GB en_US es eu fi fr gl id lt nl pa pl pt pt_BR sk sl tg ug uk zh_CN zh_TW"
for lang in $ILINGUAS; do
	IUSE="${IUSE} linguas_${lang}"
done

DEPEND="dev-libs/libxml2
	sys-libs/zlib
	!gnutls? (
		>=dev-libs/openssl-1.0.1h:0[static-libs?]
	)
	gnutls? (
		>=net-libs/gnutls-3[static-libs?] dev-libs/nettle
		app-misc/ca-certificates
	)
	gssapi? ( virtual/krb5 )
	libproxy? ( net-libs/libproxy )
	nls? ( virtual/libintl )"
RDEPEND="${DEPEND}
	sys-apps/iproute2
	!<sys-apps/openrc-0.13"
DEPEND="${DEPEND}
	virtual/pkgconfig
	doc? ( ${PYTHON_DEPS} sys-apps/groff )
	java? ( >=virtual/jdk-1.6 )
	nls? ( sys-devel/gettext )"

tun_tap_check() {
	ebegin "Checking for TUN/TAP support"
	if { ! linux_chkconfig_present TUN; }; then
		eerror "Please enable TUN/TAP support in your kernel config, found at:"
		eerror
		eerror "  Device Drivers  --->"
		eerror "    [*] Network device support  --->"
		eerror "      <*>   Universal TUN/TAP device driver support"
		eerror
		eerror "and recompile your kernel ..."
		die "no CONFIG_TUN support detected!"
	fi
	eend $?
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup

	if use doc; then
		python-any-r1_pkg_setup
	fi

	if use kernel_linux; then
		get_version
		if linux_config_exists; then
			tun_tap_check
		else
			ewarn "Was unable to determine your kernel .config"
			ewarn "Please note that OpenConnect requires CONFIG_TUN to be set in your"
			ewarn "kernel .config, Without it, it will not work correctly."
			# We don't die here, so it's possible to compile this package without
			# kernel sources available. Required for cross-compilation.
		fi
	fi
}

src_configure() {
	strip-linguas $ILINGUAS
	echo ${LINGUAS} > po/LINGUAS
	if ! use doc; then
		# If the python cannot be found, the docs will not build
		sed -e 's#"${ac_cv_path_PYTHON}"#""#' -i configure || die
	fi

	# stoken and liboath not in portage
	econf \
		--with-vpnc-script="${EPREFIX}/etc/openconnect/openconnect.sh" \
		$(use_enable static-libs static) \
		$(use_enable nls ) \
		$(use_with !gnutls openssl) \
		$(use_with gnutls ) \
		$(use_with libproxy) \
		--without-stoken \
		$(use_with gssapi) \
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
