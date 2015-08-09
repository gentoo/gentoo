# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2"

DESCRIPTION="Elliptics network is a fault tolerant key/value storage without dedicated metadata servers"
HOMEPAGE="http://www.ioremap.net/projects/elliptics"
LICENSE="GPL-2"
SLOT="0"

inherit user eutils python flag-o-matic cmake-utils

KEYWORDS="~x86 ~amd64"
IUSE="fastcgi python"
RDEPEND="app-arch/snappy
	dev-libs/openssl
	fastcgi? ( dev-libs/fcgi )
	net-misc/elliptics-eblob
	dev-libs/boost[python]
	dev-libs/libevent
	dev-libs/leveldb
	dev-libs/smack
	dev-db/kyotocabinet
	net-misc/cocaine-core
	net-libs/zeromq"
DEPEND="${RDEPEND}"

SRC_URI="https://github.com/reverbrain/elliptics/archive/v${PV}.tar.gz -> ${P}.tar.gz"

pkg_setup() {
	enewgroup elliptics
	enewuser elliptics -1 -1 /dev/null elliptics
	python_set_active_version 2
	python_pkg_setup
}

src_configure(){
	use python && filter-ldflags -Wl,--as-needed
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install

	use fastcgi && example/fcgi/lighttpd-fastcgi-elliptics.conf
	dodoc doc/design_notes.txt \
		doc/io_storage_backend.txt \
		example/EXAMPLE \
		example/ioserv.conf

	# init script stuff
	# too many changes since the old version, needs to be re-added
	#newinitd "${FILESDIR}"/elliptics.initd elliptics || die
	#newconfd "${FILESDIR}"/elliptics.confd elliptics || die

	# tune default config
	sed -i 's#log = /dev/stderr#log = syslog#' "${S}/example/ioserv.conf"
	sed -i 's#root = /tmp/root#root = /var/spool/elliptics#' "${S}/example/ioserv.conf"
	sed -i 's#daemon = 0#daemon = 1#' "${S}/example/ioserv.conf"
	sed -i 's#history = /tmp/history#history = /var/run/elliptics#' "${S}/example/ioserv.conf"

	# configs
	insinto /etc/elliptics
	doins "${S}/example/ioserv.conf"

	keepdir /var/{spool,run}/elliptics
	fowners elliptics:elliptics /var/{spool,run}/elliptics
	fperms 0750 /var/{spool,run}/elliptics
}
