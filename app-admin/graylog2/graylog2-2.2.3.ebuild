# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Free and open source log management"
HOMEPAGE="https://graylog.org"
SRC_URI="https://packages.graylog2.org/releases/graylog/graylog-${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

MY_PN="graylog"
S="${WORKDIR}/${MY_PN}-${PV}"

INSTALL_DIR="/usr/share/graylog2"
DATA_DIR="/var/lib/graylog2"

QA_PREBUILT="${INSTALL_DIR}/lib/sigar/libsigar*"
RESTRICT="strip"

RDEPEND="virtual/jdk:1.8"

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
	rm lib/sigar/libsigar-*freebsd*so \
		lib/sigar/libsigar-*solaris*so \
		lib/sigar/libsigar-*hpux*.sl \
		lib/sigar/libsigar-*macosx*.dylib \
		lib/sigar/libsigar-ia64-*.so \
		lib/sigar/libsigar-ppc-*.so \
		lib/sigar/libsigar-s390x*.so \
		lib/sigar/*winnt* || die "Failed in removing unsupported platform libraries"

	# remove plugins
	rm plugin/graylog-plugin-anonymous-usage-statistics-${PV}.jar || die

	# gentoo specific paths
	sed -i "s@\(node_id_file = \).*@\1${DATA_DIR}/node-id@g; \
		s@\(message_journal_dir = \).*@\1${DATA_DIR}/data/journal@g; \
		s@#\(content_packs_dir = \).*@\1/${DATA_DIR}/data/contentpacks@g" \
		graylog.conf.example || die
}

src_compile() {
	einfo "Nothing to compile; upstream supplies JAR only"
}

src_install() {
	insinto /etc/graylog2
	doins graylog.conf.example

	insinto ${DATA_DIR}/data/contentpacks
	doins data/contentpacks/grok-patterns.json

	insinto "${INSTALL_DIR}"
	doins *

	doins -r lib plugin

	newinitd "${FILESDIR}/initd-r1" graylog2
	newconfd "${FILESDIR}/confd-r1" graylog2
}
