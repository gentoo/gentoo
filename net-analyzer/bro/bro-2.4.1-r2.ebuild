# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python2_7 )
inherit cmake-utils python-single-r1

DESCRIPTION="The Bro Network Security Monitor"
HOMEPAGE="https://www.bro.org"
SRC_URI="https://www.bro.org/downloads/release/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+broccoli +broctl -broker curl debug geoip ipv6 jemalloc +python -ruby tcmalloc static-libs +tools"

RDEPEND="app-shells/bash:0
	dev-libs/openssl:0
	net-analyzer/ipsumdump
	net-dns/bind-tools
	net-libs/libpcap
	sys-libs/zlib
	broker? ( =dev-libs/actor-framework-0.13.2* )
	broctl? ( virtual/mta )
	curl? ( net-misc/curl )
	geoip? ( dev-libs/geoip )
	ipv6? ( net-analyzer/ipsumdump[ipv6] )
	jemalloc? ( dev-libs/jemalloc )
	python? ( ${PYTHON_DEPS} )
	ruby? ( >=dev-lang/ruby-1.8:= )
	tcmalloc? ( dev-util/google-perftools )"
DEPEND="${RDEPEND}
	>=dev-lang/swig-3.0.3
	dev-lang/perl"

REQUIRED_USE="broker? ( python )
	broctl? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )"
PATCHES=( "${FILESDIR}/bro-2.4.1-remove-unnecessary-remove.patch"
	"${FILESDIR}/bro-2.4.1-fix-python-install-dir.patch" )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEBUG=$(usex debug true false)
		-DENABLE_JEMALLOC=$(usex jemalloc true false)
		-DDISABLE_PERFTOOLS=$(usex tcmalloc false true)
		-DENABLE_BROKER=$(usex broker true false)
		-DENABLE_CXX11=$(usex broker true false)
		-DBROKER_PYTHON_PREFIX="/usr"
		-DLIBCAF_INCLUDE_DIR_CORE="/usr/include/"
		-DLIBCAF_INCLUDE_DIR_IO="/usr/include/"
		-DLIBCAF_ROOT_DIR="/usr"
		-DENABLE_STATIC=$(usex static-libs true false)
		-DINSTALL_BROCCOLI=$(usex broccoli true false)
		-DINSTALL_BROCTL=$(usex broctl true false)
		-DINSTALL_AUX_TOOLS=$(usex tools true false)
		-DENABLE_MOBILE_IPV6=$(usex ipv6 true false)
		-DDISABLE_RUBY_BINDINGS=$(usex ruby false true)
		-DDISABLE_PYTHON_BINDINGS=$(usex python false true)
		-DBRO_LOG_DIR="/var/log/bro/"
		-DBRO_SPOOL_DIR="/var/spool/bro/"
		-DBRO_ETC_INSTALL_DIR="/etc/bro/"
		-DINSTALL_LIB_DIR="/usr/$(get_libdir)"
		-DPY_MOD_INSTALL_DIR="$(python_get_sitedir)"
	)

	cmake-utils_src_configure
}
