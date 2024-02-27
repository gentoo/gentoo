# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature pax-utils systemd xdg-utils

if [[ ${PV} != *9999* ]]; then
	MY_P=${PN}-${PV/_/-}
	if [[ ${PV} == *_rc* ]] ; then
		SRC_URI="https://github.com/quassel/quassel/archive/refs/tags/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	else
		SRC_URI="https://quassel-irc.org/pub/${MY_P}.tar.bz2"
		KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux"
	fi
	S="${WORKDIR}/${MY_P}"
else
	EGIT_REPO_URI=( "https://github.com/${PN}/${PN}" )
	inherit git-r3
fi

DESCRIPTION="Qt/KDE IRC client supporting a remote daemon for 24/7 connectivity"
HOMEPAGE="https://quassel-irc.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE="bundled-icons crypt +dbus gui kde ldap monolithic oxygen postgres +server spell syslog test urlpreview"

REQUIRED_USE="
	|| ( gui server monolithic )
	crypt? ( || ( server monolithic ) )
	kde? ( dbus spell )
	ldap? ( || ( server monolithic ) )
	postgres? ( || ( server monolithic ) )
	spell? ( || ( gui monolithic ) )
	syslog? ( || ( server monolithic ) )
"

RESTRICT="!test? ( test )"

SERVER_DEPEND="
	acct-group/quassel
	acct-user/quassel
	crypt? ( app-crypt/qca:2[ssl] )
	ldap? ( net-nds/openldap:= )
	postgres? ( dev-qt/qtsql:5[postgres] )
	!postgres? (
		dev-qt/qtsql:5[sqlite]
		dev-db/sqlite:3[threadsafe(+),-secure-delete]
	)
	syslog? ( virtual/logger )
"
GUI_DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	!bundled-icons? (
		kde-frameworks/breeze-icons:*
		oxygen? ( kde-frameworks/oxygen-icons:* )
	)
	dbus? (
		>=dev-libs/libdbusmenu-qt-0.9.3_pre20140619
		dev-qt/qtdbus:5
	)
	kde? (
		kde-frameworks/kconfigwidgets:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/knotifications:5
		kde-frameworks/knotifyconfig:5
		kde-frameworks/ktextwidgets:5
		kde-frameworks/kwidgetsaddons:5
		kde-frameworks/kxmlgui:5
	)
	spell? ( kde-frameworks/sonnet:5 )
	urlpreview? ( dev-qt/qtwebengine:5[widgets] )
"
RDEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	sys-libs/zlib
	monolithic? (
		${SERVER_DEPEND}
		${GUI_DEPEND}
	)
	!monolithic? (
		server? ( ${SERVER_DEPEND} )
		gui? ( ${GUI_DEPEND} )
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-qt/qttest:5
	)
"
BDEPEND="
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules:0
"

DOCS=( AUTHORS ChangeLog README.md )

src_configure() {
	local mycmakeargs=(
		-DUSE_CCACHE=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DEMBED_DATA=OFF
		-DWITH_WEBKIT=OFF
		-DWITH_BUNDLED_ICONS=$(usex bundled-icons)
		-DWANT_QTCLIENT=$(usex gui)
		-DWITH_KDE=$(usex kde)
		-DWITH_LDAP=$(usex ldap)
		-DWANT_MONO=$(usex monolithic)
		-DWITH_OXYGEN_ICONS=$(usex oxygen)
		-DWANT_CORE=$(usex server)
		-DBUILD_TESTING=$(usex test)
		-DWITH_WEBENGINE=$(usex urlpreview)
	)

	# bug #830708
	if use gui || use monolithic ; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_LibsnoreQt5=ON
			$(cmake_use_find_package dbus dbusmenu-qt5)
			$(cmake_use_find_package dbus Qt5DBus)
			$(cmake_use_find_package spell KF5Sonnet)
		)
	fi

	if use server || use monolithic ; then
		mycmakeargs+=( $(cmake_use_find_package crypt Qca-qt5) )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use server ; then
		# Needs PaX marking, bug #346255
		pax-mark m "${ED}"/usr/bin/quasselcore

		# Init scripts & systemd unit
		newinitd "${FILESDIR}"/quasselcore.init-r1 quasselcore
		newconfd "${FILESDIR}"/quasselcore.conf-r1 quasselcore
		systemd_dounit "${FILESDIR}"/quasselcore.service

		# logrotate
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/quassel.logrotate quassel
	fi
}

src_test() {
	LD_LIBRARY_PATH="${BUILD_DIR}/lib:${LD_LIBRARY_PATH}" cmake_src_test
}

pkg_postinst() {
	if use monolithic ; then
		elog "Information on how to enable SSL support for client/core connections"
		elog "is available at: https://bugs.quassel-irc.org/projects/quassel-irc/wiki/Client-Core_SSL_support"
	fi

	if use server ; then
		einfo "If you want to generate SSL certificate, remember to run:"
		einfo "    emerge --config =${CATEGORY}/${PF}"
	fi

	if use server || use monolithic ; then
		optfeature "running Quassel within an ident daemon" "net-misc/oidentd"
	fi

	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

pkg_config() {
	if use server ; then
		# Generate the pem file only when it does not already exist
		QUASSEL_DIR="${EROOT}"/var/lib/${PN}

		if [[ ! -f "${QUASSEL_DIR}/quasselCert.pem" ]] ; then
			einfo "Generating Quassel SSL certificate to: \"${QUASSEL_DIR}/quasselCert.pem\""
			openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
				-keyout "${QUASSEL_DIR}/quasselCert.pem" \
				-out "${QUASSEL_DIR}/quasselCert.pem" || die

			# Permissions for the key
			chown ${PN}:${PN} "${QUASSEL_DIR}/quasselCert.pem" || die
			chmod 400 "${QUASSEL_DIR}/quasselCert.pem" || die
		else
			einfo "Certificate \"${QUASSEL_DIR}/quasselCert.pem\" already exists."
			einfo "Remove it if you want to create new one."
		fi
	fi
}
