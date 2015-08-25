# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils eutils pax-utils systemd user versionator

EGIT_REPO_URI="git://git.quassel-irc.org/quassel"
[[ "${PV}" == "9999" ]] && inherit git-r3

DESCRIPTION="Qt/KDE IRC client supporting a remote daemon for 24/7 connectivity"
HOMEPAGE="http://quassel-irc.org/"
[[ "${PV}" == "9999" ]] || SRC_URI="http://quassel-irc.org/pub/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~sparc-solaris"
SLOT="0"
IUSE="ayatana crypt dbus debug kde monolithic phonon postgres qt5 +server +ssl syslog webkit X"

SERVER_RDEPEND="
	qt5? (
		dev-qt/qtscript:5
		crypt? ( app-crypt/qca:2[openssl,qt5] )
		postgres? ( dev-qt/qtsql:5[postgres] )
		!postgres? ( dev-qt/qtsql:5[sqlite] dev-db/sqlite:3[threadsafe(+),-secure-delete] )
	)
	!qt5? (
		dev-qt/qtscript:4
		crypt? ( app-crypt/qca:2[openssl,qt4(+)] )
		postgres? ( dev-qt/qtsql:4[postgres] )
		!postgres? ( dev-qt/qtsql:4[sqlite] dev-db/sqlite:3[threadsafe(+),-secure-delete] )
	)
	syslog? ( virtual/logger )
"

GUI_RDEPEND="
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dbus? (
			>=dev-libs/libdbusmenu-qt-0.9.3_pre20140619[qt5]
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
			kde-frameworks/sonnet:5
		)
		phonon? ( media-libs/phonon[qt5] )
		webkit? ( dev-qt/qtwebkit:5 )
	)
	!qt5? (
		dev-qt/qtgui:4
		ayatana? ( dev-libs/libindicate-qt )
		dbus? (
			>=dev-libs/libdbusmenu-qt-0.9.3_pre20140619[qt4(+)]
			dev-qt/qtdbus:4
			kde? (
				kde-base/kdelibs:4
				kde-apps/oxygen-icons
				ayatana? ( kde-misc/plasma-widget-message-indicator )
			)
		)
		phonon? ( || ( media-libs/phonon[qt4] dev-qt/qtphonon:4 ) )
		webkit? ( dev-qt/qtwebkit:4 )
	)
"

RDEPEND="
	sys-libs/zlib
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5[ssl?]
	)
	!qt5? ( dev-qt/qtcore:4[ssl?] )
	monolithic? (
		${SERVER_RDEPEND}
		${GUI_RDEPEND}
	)
	!monolithic? (
		server? ( ${SERVER_RDEPEND} )
		X? ( ${GUI_RDEPEND} )
	)
"
DEPEND="${RDEPEND}
	qt5? (
		dev-qt/linguist-tools:5
		kde-frameworks/extra-cmake-modules
	)
"

DOCS=( AUTHORS ChangeLog README )

PATCHES=( "${FILESDIR}/${P}-qt55.patch" )

REQUIRED_USE="
	|| ( X server monolithic )
	ayatana? ( || ( X monolithic ) )
	crypt? ( || ( server monolithic ) )
	dbus? ( || ( X monolithic ) )
	kde? ( || ( X monolithic ) phonon )
	phonon? ( || ( X monolithic ) )
	postgres? ( || ( server monolithic ) )
	qt5? ( !ayatana )
	syslog? ( || ( server monolithic ) )
	webkit? ( || ( X monolithic ) )
"

pkg_setup() {
	if use server; then
		QUASSEL_DIR=/var/lib/${PN}
		QUASSEL_USER=${PN}
		# create quassel:quassel user
		enewgroup "${QUASSEL_USER}"
		enewuser "${QUASSEL_USER}" -1 -1 "${QUASSEL_DIR}" "${QUASSEL_USER}"
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package ayatana IndicateQt)
		$(cmake-utils_use_find_package crypt QCA2)
		$(cmake-utils_use_find_package crypt QCA2-QT5)
		$(cmake-utils_use_find_package dbus dbusmenu-qt)
		$(cmake-utils_use_find_package dbus dbusmenu-qt5)
		$(cmake-utils_use_with kde)
		$(cmake-utils_use_with !kde OXYGEN)
		$(cmake-utils_use_want monolithic MONO)
		$(cmake-utils_use_find_package phonon)
		$(cmake-utils_use_find_package phonon Phonon4Qt5)
		$(cmake-utils_use_use qt5)
		$(cmake-utils_use_want server CORE)
		$(cmake-utils_use_with webkit)
		$(cmake-utils_use_want X QTCLIENT)
		-DEMBED_DATA=OFF
		-DCMAKE_SKIP_RPATH=ON
	)

	# Something broke upstream detection since Qt 5.5
	if use ssl ; then
		mycmakeargs+=("-DHAVE_SSL=TRUE")
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use server ; then
		# needs PAX marking wrt bug#346255
		pax-mark m "${ED}/usr/bin/quasselcore"

		# prepare folders in /var/
		keepdir "${QUASSEL_DIR}"
		fowners "${QUASSEL_USER}":"${QUASSEL_USER}" "${QUASSEL_DIR}"

		# init scripts & systemd unit
		newinitd "${FILESDIR}"/quasselcore.init quasselcore
		newconfd "${FILESDIR}"/quasselcore.conf quasselcore
		systemd_dounit "${FILESDIR}"/quasselcore.service

		# logrotate
		insinto /etc/logrotate.d
		newins "${FILESDIR}/quassel.logrotate" quassel
	fi
}

pkg_postinst() {
	if use monolithic && use ssl ; then
		elog "Information on how to enable SSL support for client/core connections"
		elog "is available at http://bugs.quassel-irc.org/wiki/quassel-irc."
	fi

	if use server; then
		einfo "If you want to generate SSL certificate remember to run:"
		einfo "	emerge --config =${CATEGORY}/${PF}"
	fi

	if use server || use monolithic ; then
		einfo "Quassel can use net-misc/oidentd package if installed on your system."
		einfo "Consider installing it if you want to run quassel within identd daemon."
	fi

	# temporary info mesage
	if use server && [[ $(get_version_component_range 2 ${REPLACING_VERSIONS}) -lt 7 ]]; then
		echo
		ewarn "Please note that all configuration moved from"
		ewarn "/home/\${QUASSEL_USER}/.config/quassel-irc.org/"
		ewarn "to: ${QUASSEL_DIR}."
		echo
		ewarn "For migration, stop the core, move quasselcore files (pretty much"
		ewarn "everything apart from quasselclient.conf and settings.qss) into"
		ewarn "new location and then start server again."
	fi
}

pkg_config() {
	if use server && use ssl; then
		# generate the pem file only when it does not already exist
		if [ ! -f "${QUASSEL_DIR}/quasselCert.pem" ]; then
			einfo "Generating QUASSEL SSL certificate to: \"${QUASSEL_DIR}/quasselCert.pem\""
			openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
				-keyout "${QUASSEL_DIR}/quasselCert.pem" \
				-out "${QUASSEL_DIR}/quasselCert.pem"
			# permissions for the key
			chown ${QUASSEL_USER}:${QUASSEL_USER} "${QUASSEL_DIR}/quasselCert.pem"
			chmod 400 "${QUASSEL_DIR}/quasselCert.pem"
		else
			einfo "Certificate \"${QUASSEL_DIR}/quasselCert.pem\" already exists."
			einfo "Remove it if you want to create new one."
		fi
	fi
}
