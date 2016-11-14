# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit user

DESCRIPTION="Free and open source log management"
HOMEPAGE="https://graylog.org"
SRC_URI="https://packages.graylog2.org/releases/graylog/graylog-${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

MY_PN="graylog"
S="${WORKDIR}/${MY_PN}-${PV}"

QA_PREBUILT="/usr/share/graylog2/lib/sigar/libsigar*"
RESTRICT="strip"

DEPEND=""
RDEPEND="virtual/jdk:1.8"

INSTALL_DIR="/usr/share/graylog2"

pkg_setup() {
	enewgroup graylog
	enewuser graylog -1 -1 -1 graylog
}

src_prepare() {
	default
	# graylogctl is replaced by our own initd
	rm -r bin
	# Stick to architecture of build host
	if ! use amd64; then
		rm -r lib/sigar/libsigar-amd64-*.so || die "Failed in removing AMD64 support libraries"
	fi
	if ! use ppc64; then
		rm -r lib/sigar/libsigar-ppc64-*.so || die "Failed in removing PPC64 support libraries"
	fi
	if ! use x86; then
		rm -r lib/sigar/libsigar-x86-*.so || die "Failed in removing X86 support libraries"
	fi
	# Currently unsupported platforms
	# QA warning galore but testing/patches welcome
	rm -r lib/sigar/libsigar-ia64-*.so || die "Failed in removing IA64 support libraries"
	rm -r lib/sigar/libsigar-ppc-*.so || die "Failed in removing PPC support libraries"
	rm -r lib/sigar/libsigar-*-freebsd-*.so || die "Failed in removing FreeBSD support libraries"
	rm -r lib/sigar/libsigar-pa-*.sl || die "Failed in removing HPPA support libraries"
	rm -r lib/sigar/libsigar-*-solaris.so || die "Failed in removing Solaris support libraries"
}

src_compile() {
	einfo "Nothing to compile; upstream supplies JAR only"
}

src_install() {
	insinto /etc/graylog2
	doins graylog.conf.example
	insinto "${INSTALL_DIR}"
	doins *
	newinitd "${FILESDIR}/initd" graylog2
	newconfd "${FILESDIR}/confd" graylog2
}
