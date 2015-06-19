# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-sap-ccms-plugin/nagios-sap-ccms-plugin-0.8.ebuild,v 1.6 2014/01/26 03:45:15 creffett Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

MY_P="sap-ccms-plugin-${PV}"

DESCRIPTION="Nagios plugin that provides an interface to SAP CCMS
Infrastructure"
HOMEPAGE="http://sourceforge.net/projects/nagios-sap-ccms/"
SRC_URI="mirror://sourceforge/nagios-sap-ccms/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

QA_PRESTRIPPED="/usr/lib/librfccm.so"
QA_FLAGS_IGNORED="/usr/lib/librfccm.so"

DEPEND="
	net-analyzer/nagios-core
	dev-libs/iniparser
"
RDEPEND=${DEPEND}

S="${WORKDIR}/${PN/-plugin*}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i src/sap_moni/* \
		-e 's|#include "iniparser.h"|#include <iniparser.h>|g' \
		|| die "sed sap_moni/"
}

src_compile() {
	emake -C src CC=$(tc-getCC)
}

src_install() {
	cd "${S}/src"
	exeinto /usr/$(get_libdir)/nagios/plugins

	for file in {check_sap{,_cons,_instance,_instance_cons,_mult_no_thr,_multiple,_system,_system_cons},create_cfg,sap_change_thr}
	do
		doexe ${file}
	done

	chown -R root:nagios "${D}"/usr/$(get_libdir)/nagios/plugins || die "Failed Chown of ${D}usr/$(get_libdir)/nagios/plugins"

	dolib.so sap_moni.so
	newlib.so $(readlink librfccm.so) librfccm.so
	cd "${S}/config"

	dodir /etc/sapmon
	insinto /etc/sapmon
	doins "${S}"/config/*
}

pkg_postinst() {
	elog "Have a look at /etc/sapmon for configuring ${PN}"
	elog "Further information can be found at"
	elog "http://nagios-sap-ccms.sourceforge.net/"
}
