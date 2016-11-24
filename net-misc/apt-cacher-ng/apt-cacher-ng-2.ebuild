# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils toolchain-funcs user

DESCRIPTION="Yet another caching HTTP proxy for Debian/Ubuntu software packages"
HOMEPAGE="
	http://www.unix-ag.uni-kl.de/~bloch/acng/
	http://packages.qa.debian.org/a/apt-cacher-ng.html
"
LICENSE="BSD-4 ZLIB public-domain"
SLOT="0"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.orig.tar.xz"

KEYWORDS="~amd64 ~x86"
IUSE="doc fuse systemd tcpd"

COMMON_DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	dev-libs/openssl:*
	sys-libs/zlib
	systemd? (
		sys-apps/systemd
	)
"
DEPEND="
	${COMMON_DEPEND}
	dev-util/cmake
	>sys-devel/gcc-4.8
	virtual/pkgconfig
"
RDEPEND="
	${COMMON_DEPEND}
	dev-lang/perl
	fuse? ( sys-fs/fuse )
	tcpd? ( sys-apps/tcp-wrappers )
"

S=${WORKDIR}/${P/_}

pkg_pretend() {
	if [[ $(gcc-major-version) -lt 4 ]]; then
		die "GCC 4.8 or greater is required but you have $(gcc-major-version).$(gcc-minor-version)"
	elif [[ $(gcc-major-version) = 4 ]] && [[ $(gcc-minor-version) -lt 8 ]]; then
		die "GCC 4.8 or greater is required but you have $(gcc-major-version).$(gcc-minor-version)"
	fi
}

pkg_setup() {
	# add new user & group for daemon
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_configure(){
	mycmakeargs=( "-DCMAKE_INSTALL_PREFIX=/usr" )
	if use fuse; then
		mycmakeargs+=( "-DHAVE_FUSE_25=yes" )
	else
		mycmakeargs+=( "-DHAVE_FUSE_25=no" )
	fi
	if use tcpd; then
		mycmakeargs=( "-DHAVE_LIBWRAP=yes" )
	else
		mycmakeargs=( "-DHAVE_LIBWRAP=no" )
	fi

	cmake-utils_src_configure
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
	dosbin ${PN}
	if use fuse; then
		dobin acngfs
	fi
	popd

	newinitd "${FILESDIR}"/initd-r1 ${PN}
	newconfd "${FILESDIR}"/confd ${PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/logrotate ${PN}

	doman doc/man/${PN}*
	if use fuse; then
		doman doc/man/acngfs*
	fi

	# Documentation
	dodoc doc/README TODO VERSION INSTALL ChangeLog
	if use doc; then
		dodoc doc/*.pdf
		dohtml doc/html/*
		docinto examples/conf
		dodoc conf/*
	fi

	# perl daily cron script
	dosbin scripts/expire-caller.pl
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/cron.daily ${PN}

	# default configuration
	insinto /etc/${PN}
	newins "${CMAKE_BUILD_DIR}"/conf/acng.conf ${PN}.conf
	doins $( echo conf/* | sed 's|conf/acng.conf.in||g' )

	keepdir /var/log/${PN}
	# Some directories must exists
	keepdir /var/log/${PN}
	fowners -R ${PN}:${PN} \
		/etc/${PN} \
		/var/log/${PN}
}
