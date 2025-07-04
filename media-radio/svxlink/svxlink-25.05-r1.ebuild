# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake flag-o-matic systemd xdg-utils

CMAKE_USE_DIR="${S}/src"

DESCRIPTION="Multi Purpose Voice Services System, including Qtel for EchoLink"
HOMEPAGE="https://www.svxlink.org"
SRC_URI="https://github.com/sm0svx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ogg qt5 rtlsdr"

DEPEND="dev-lang/tcl:=
	dev-libs/jsoncpp:=
	dev-libs/libgcrypt:=
	=dev-libs/libgpiod-1*:=
	dev-libs/libsigc++:2
	dev-libs/openssl:=
	dev-libs/popt
	media-libs/alsa-lib
	media-libs/opus
	media-libs/speex
	media-sound/gsm
	net-misc/curl
	ogg? ( media-libs/libogg )
	rtlsdr? ( net-wireless/rtl-sdr:= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)"
RDEPEND="${DEPEND}
	acct-group/svxlink
	acct-user/svxlink"
BDEPEND="
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )"

PATCHES=( "${FILESDIR}"/${PN}-25.05-fix-missing-const.patch )

src_prepare() {
	# fix build for MUSL (bug #936813, #942749)
	if use elibc_musl ; then
		eapply -p1 "${FILESDIR}/${P}-musl.patch"
		eapply -p1 "${FILESDIR}/${P}-musl-2.patch"
	fi
	if ! use ogg ; then
		# drop automatic discovery of dependency
		sed -i -e "s/find_package(OGG)/#/g" \
				src/async/audio/CMakeLists.txt || die
	fi
	if ! use rtlsdr ; then
		# drop automatic discovery of dependency
		sed -i -e "s/find_package(RtlSdr)/#/g" \
				src/svxlink/trx/CMakeLists.txt || die
	fi
	cmake_src_prepare
	# drop deprecated desktop category (bug #475730)
	sed -i -e "s:Categories=Application;:Categories=:g" src/qtel/qtel.desktop || die
}

src_configure() {
	# -Wodr warnings, see bug #860414
	filter-lto

	local mycmakeargs=(
		-DUSE_QT="$(usex qt5)"
		-DSYSCONF_INSTALL_DIR=/etc
		-DLOCAL_STATE_DIR=/var
		-DUSE_OSS=NO
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	fowners -R svxlink:svxlink /var/spool/svxlink

	doman src/doc/man/*.1 src/doc/man/*.5

	insinto /etc/logrotate.d
	doins   distributions/gentoo/etc/logrotate.d/*

	newinitd "${FILESDIR}"/remotetrx.init remotetrx
	newinitd "${FILESDIR}"/svxlink.init svxlink
	newconfd "${FILESDIR}"/remotetrx.rc remotetrx
	newconfd "${FILESDIR}"/svxlink.rc svxlink

	systemd_dounit "${FILESDIR}"/remotetrx.service
	systemd_dounit "${FILESDIR}"/svxlink.service

	keepdir /var/lib/${PN}/pki
	keepdir /var/spool/${PN}/propagation_monitor
	keepdir /var/spool/${PN}/qso_recorder
	keepdir /var/spool/${PN}/voice_mail
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
