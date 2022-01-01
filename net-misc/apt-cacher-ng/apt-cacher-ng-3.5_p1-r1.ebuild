# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils user

DESCRIPTION="Yet another caching HTTP proxy for Debian/Ubuntu software packages"
HOMEPAGE="
	https://www.unix-ag.uni-kl.de/~bloch/acng/
	https://packages.qa.debian.org/a/apt-cacher-ng.html
"
LICENSE="BSD-4 ZLIB public-domain"
SLOT="0"
SRC_URI="
	mirror://debian/pool/main/a/${PN}/${PN}_${PV/_*}.orig.tar.xz
	mirror://debian/pool/main/a/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"

KEYWORDS="~amd64 ~x86"
IUSE="doc fuse systemd tcpd"

COMMON_DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	dev-libs/libevent:=
	dev-libs/openssl:0=
	sys-libs/zlib
	systemd? (
		sys-apps/systemd
	)
"
BDEPEND="
	${COMMON_DEPEND}
	dev-util/cmake
	virtual/pkgconfig
"
RDEPEND="
	${COMMON_DEPEND}
	dev-lang/perl
	fuse? ( sys-fs/fuse )
	tcpd? ( sys-apps/tcp-wrappers )
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.3.1-flags.patch
	"${FILESDIR}"/${PN}-3.5-perl-syntax.patch
	"${WORKDIR}"/debian/patches/debian-changes
)
S=${WORKDIR}/${P/_*}

pkg_setup() {
	# add new user & group for daemon
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_configure() {
	local mycmakeargs=()
	if use fuse; then
		mycmakeargs+=( "-DHAVE_FUSE_25=yes" )
	else
		mycmakeargs+=( "-DHAVE_FUSE_25=no" )
	fi
	if use tcpd; then
		mycmakeargs+=( "-DHAVE_LIBWRAP=yes" )
	else
		mycmakeargs+=( "-DHAVE_LIBWRAP=no" )
	fi
	if tc-ld-is-gold; then
		mycmakeargs+=( "-DUSE_GOLD=yes" )
	else
		mycmakeargs+=( "-DUSE_GOLD=no" )
	fi

	cmake-utils_src_configure

	sed -i -e '/LogDir/s|/var/tmp|/var/log/'"${PN}"'|g' "${BUILD_DIR}"/conf/acng.conf || die
}

src_install() {
	pushd "${BUILD_DIR}" || die
	dosbin ${PN} acngtool
	dolib.so libsupacng.so
	if use fuse; then
		dobin acngfs
	fi
	popd || die

	newinitd "${FILESDIR}"/initd-r2 ${PN}
	newconfd "${FILESDIR}"/confd-r1 ${PN}

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

		docinto html
		dodoc doc/html/*

		find conf -name '*.gz' -exec gzip -d {} \; || die
		docinto examples/conf
		dodoc conf/*
	fi

	newdoc "${WORKDIR}"/debian/changelog debian.changelog

	# perl daily cron script
	dosbin scripts/expire-caller.pl
	insinto /etc/cron.daily
	newins "${FILESDIR}"/cron.daily ${PN}

	# default configuration
	insinto /etc/${PN}
	newins "${BUILD_DIR}"/conf/acng.conf ${PN}.conf
	doins $( echo conf/* | sed 's|conf/acng.conf.in||g' )

	keepdir /var/log/${PN}
	# Some directories must exists
	keepdir /var/log/${PN}
	fowners -R ${PN}:${PN} \
		/etc/${PN} \
		/var/log/${PN}
}
