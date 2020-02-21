# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit user

DESCRIPTION="Free and open source log management"
HOMEPAGE="https://www.graylog.org"
SRC_URI="https://packages.graylog2.org/releases/graylog/graylog-${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
RESTRICT="strip"

RDEPEND="virtual/jdk:1.8"

DOCS=(
	COPYING README.markdown UPGRADING.rst
)

GRAYLOG_DATA_DIR="/var/lib/graylog2"
GRAYLOG_INSTALL_DIR="/usr/share/graylog2"
QA_PREBUILT="${GRAYLOG_INSTALL_DIR}/lib/sigar/libsigar*"

S="${WORKDIR}/graylog-${PV}"

pkg_setup() {
	enewgroup graylog
	enewuser graylog -1 -1 -1 graylog
}

src_prepare() {
	default

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

	# gentoo specific paths
	sed -i "s@\(node_id_file = \).*@\1${GRAYLOG_DATA_DIR}/node-id@g; \
		s@\(message_journal_dir = \).*@\1${GRAYLOG_DATA_DIR}/data/journal@g; \
		s@#\(content_packs_dir = \).*@\1${GRAYLOG_DATA_DIR}/data/contentpacks@g" \
		graylog.conf.example || die
}

src_install() {
	default

	insinto /etc/graylog2
	doins graylog.conf.example

	insinto "${GRAYLOG_DATA_DIR}/data/contentpacks"
	doins data/contentpacks/grok-patterns.json

	insinto "${GRAYLOG_INSTALL_DIR}"
	doins graylog.jar
	doins -r lib plugin

	newconfd "${FILESDIR}/confd-r2" graylog2
	newinitd "${FILESDIR}/initd-r2" graylog2
}

pkg_postinst() {
	ewarn "Graylog does not depend on need.net any more (#439092)."
	ewarn
	ewarn "Please configure rc_need according to your binding address in:"
	ewarn "/etc/conf.d/graylog2"
}
