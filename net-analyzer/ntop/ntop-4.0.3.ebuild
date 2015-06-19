# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ntop/ntop-4.0.3.ebuild,v 1.12 2015/02/02 10:05:08 jer Exp $

EAPI="2"

inherit autotools eutils user

DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="http://www.ntop.org/products/ntop/"
SRC_URI="mirror://sourceforge/ntop/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="ipv6 ssl"
#snmp support is disabled

#snmp? ( net-analyzer/net-snmp )
COMMON_DEPEND="virtual/awk
	dev-lang/perl
	sys-libs/gdbm
	dev-libs/libevent
	net-libs/libpcap
	media-libs/gd
	media-libs/libpng
	net-analyzer/rrdtool[graph]
	ssl? ( dev-libs/openssl )
	sys-libs/zlib
	>=dev-libs/geoip-1.4.5
	>=dev-lang/lua-5.1.4"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/libtool-1.4"

# Needed by xmldumpPlugin - couldn't get it to work
#	dev-libs/gdome2
#	>=dev-libs/glib-2"
RDEPEND="${COMMON_DEPEND}
	media-fonts/corefonts
	media-gfx/graphviz
	net-misc/wget
	app-arch/gzip"

pkg_setup() {
	# snmp doesn't compile in this release, disabled for now
	#if use snmp ; then
	#	ewarn "snmp plugin is under development and upstream does not recommend"
	#	ewarn "it for usage in production environment."
	#	if ! use ipv6 ; then
	#		echo
	#		eerror "snmp plugin has compilation problems without ipv6 support."
	#		eerror "For additional information see bug #121497."
	#		die "snmp without ipv6 is broken"
	#	else
	#		if ! built_with_use net-analyzer/net-snmp ipv6 ; then
	#			echo
	#			eerror "You have both ipv6 and snmp enabled."
	#			eerror "This require ipv6 support in net-analyzer/net-snmp."
	#			eerror "However, net-analyzer/net-snmp was compiled with ipv6 flag disabled."
	#			eerror "Please, re-emerge net-analyzer/net-snmp with USE=\"ipv6\"."
	#			die "net-analyzer/net-snmp was build without ipv6."
	#		fi
	#	fi
	#fi

	enewgroup ntop
	enewuser ntop -1 -1 /var/lib/ntop ntop
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	cat acinclude.m4.in acinclude.m4.ntop > acinclude.m4
	eautoreconf
}

src_configure() {
	# force disable xmldumpPlugin
	export \
		ac_cv_header_glib_h=no \
		ac_cv_header_glibconfig_h=no \
		ac_cv_header_gdome_h=no \
		ac_cv_lib_glib_g_date_julian=no \
		ac_cv_lib_xml2_xmlCheckVersion=no \
		ac_cv_lib_gdome_gdome_di_saveDocToFile=no

	econf \
		$(use_enable ipv6) \
		$(use_with ssl) \
		--with-rrd-home=/usr/lib \
		--disable-snmp \
		|| die "configure problem"
		# $(use_enable snmp)
}

src_install() {
	LC_ALL=C # apparently doesn't work with some locales (#191576 and #205382)
	emake DESTDIR="${D}" install || die "install problem"

	keepdir /var/lib/ntop &&
		fowners ntop:ntop /var/lib/ntop &&
		fperms 750 /var/lib/ntop ||
		die "failed to prepare /var/lib/ntop dir"
	insinto /var/lib/ntop
	local f
	for f in GeoIPASNum.dat GeoLiteCity.dat; do
		# Don't install included GeoIP files if newer versions are available
		[ -f "${ROOT}/var/lib/ntop/${f}" ] ||
			doins "3rd_party/${f}" ||
			die "failed to install ${f}"
	done

	dodoc AUTHORS CONTENTS ChangeLog MANIFESTO NEWS
	dodoc PORTING README SUPPORT_NTOP.txt THANKS $(find docs -type f)

	newinitd "${FILESDIR}"/ntop-initd ntop
	newconfd "${FILESDIR}"/ntop-confd ntop

	exeinto /etc/cron.monthly
	doexe "${FILESDIR}"/ntop-update-geoip-db
}

pkg_postinst() {
	elog "If this is the first time you install ntop, you need to run"
	elog "following command before starting ntop service:"
	elog "   ntop --set-admin-password"
}
