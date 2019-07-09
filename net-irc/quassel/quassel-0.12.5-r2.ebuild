# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils pax-utils systemd user versionator

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://quassel-irc.org/pub/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~sparc-solaris"
else
	EGIT_REPO_URI=( "https://github.com/${PN}/${PN}" "git://git.${PN}-irc.org/${PN}" )
	inherit git-r3
fi

DESCRIPTION="Qt/KDE IRC client supporting a remote daemon for 24/7 connectivity"
HOMEPAGE="https://quassel-irc.org/"
LICENSE="GPL-3"
SLOT="0"
IUSE="crypt dbus debug kde monolithic phonon postgres +server
snorenotify +ssl syslog urlpreview X"

SERVER_RDEPEND="
	dev-qt/qtscript:5
	crypt? ( app-crypt/qca:2[qt5(+),ssl] )
	postgres? ( dev-qt/qtsql:5[postgres] )
	!postgres? ( dev-qt/qtsql:5[sqlite] dev-db/sqlite:3[threadsafe(+),-secure-delete] )
	syslog? ( virtual/logger )
"

GUI_RDEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dbus? (
		>=dev-libs/libdbusmenu-qt-0.9.3_pre20140619[qt5(+)]
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
	phonon? ( media-libs/phonon[qt5(+)] )
	snorenotify? ( >=x11-libs/snorenotify-0.7.0 )
	urlpreview? ( dev-qt/qtwebengine:5[widgets] )
"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl?]
	sys-libs/zlib
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
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules
"

DOCS=( AUTHORS ChangeLog README.md )

REQUIRED_USE="
	|| ( X server monolithic )
	crypt? ( || ( server monolithic ) )
	dbus? ( || ( X monolithic ) )
	kde? ( || ( X monolithic ) dbus phonon )
	phonon? ( || ( X monolithic ) )
	postgres? ( || ( server monolithic ) )
	snorenotify? ( || ( X monolithic ) )
	syslog? ( || ( server monolithic ) )
"

PATCHES=( "${FILESDIR}/${P}-qt511.patch" )

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
		-DUSE_QT5=ON
		-DEMBED_DATA=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DWITH_WEBKIT=OFF
		$(cmake-utils_use_find_package crypt QCA2-QT5)
		$(cmake-utils_use_find_package dbus dbusmenu-qt5)
		$(cmake-utils_use_find_package dbus Qt5DBus)
		-DWITH_KDE=$(usex kde)
		-DWITH_OXYGEN=$(usex !kde)
		-DWANT_MONO=$(usex monolithic)
		$(cmake-utils_use_find_package phonon Phonon4Qt5)
		-DWANT_CORE=$(usex server)
		$(cmake-utils_use_find_package snorenotify LibsnoreQt5)
		-DWITH_WEBENGINE=$(usex urlpreview)
		-DWANT_QTCLIENT=$(usex X)
	)

	# Something broke upstream detection since Qt 5.5
	if use ssl ; then
		mycmakeargs+=( "-DHAVE_SSL=TRUE" )
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
		newinitd "${FILESDIR}"/quasselcore.init-r1 quasselcore
		newconfd "${FILESDIR}"/quasselcore.conf-r1 quasselcore
		systemd_dounit "${FILESDIR}"/quasselcore.service

		# logrotate
		insinto /etc/logrotate.d
		newins "${FILESDIR}/quassel.logrotate" quassel
	fi
}

pkg_postinst() {
	if use monolithic && use ssl ; then
		elog "Information on how to enable SSL support for client/core connections"
		elog "is available at http://bugs.quassel-irc.org/projects/quassel-irc/wiki/Client-Core_SSL_support."
	fi

	if use server; then
		einfo "If you want to generate SSL certificate remember to run:"
		einfo "	emerge --config =${CATEGORY}/${PF}"
	fi

	if use server || use monolithic ; then
		einfo "Quassel can use net-misc/oidentd package if installed on your system."
		einfo "Consider installing it if you want to run quassel within identd daemon."
	fi

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
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
