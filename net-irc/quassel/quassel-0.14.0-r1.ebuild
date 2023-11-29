# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils pax-utils systemd

if [[ ${PV} != *9999* ]]; then
	MY_P=${PN}-${PV/_/-}
	if [[ ${PV} == *_rc* ]] ; then
		SRC_URI="https://github.com/quassel/quassel/archive/refs/tags/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	else
		SRC_URI="https://quassel-irc.org/pub/${MY_P}.tar.bz2"
		KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86 ~amd64-linux"
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
IUSE="bundled-icons crypt +dbus debug gui kde ldap monolithic oxygen postgres +server snorenotify spell syslog test urlpreview"
RESTRICT="!test? ( test )"

SERVER_DEPEND="acct-group/quassel
	acct-user/quassel
	dev-qt/qtscript:5
	crypt? ( app-crypt/qca:2[ssl] )
	ldap? ( net-nds/openldap:= )
	postgres? ( dev-qt/qtsql:5[postgres] )
	!postgres? ( dev-qt/qtsql:5[sqlite] dev-db/sqlite:3[threadsafe(+),-secure-delete] )
	syslog? ( virtual/logger )"
GUI_DEPEND="dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	!bundled-icons? (
		kde-frameworks/breeze-icons:5
		oxygen? ( kde-frameworks/oxygen-icons:5 )
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
	snorenotify? ( >=x11-libs/snorenotify-0.7.0 )
	spell? ( kde-frameworks/sonnet:5 )
	urlpreview? ( dev-qt/qtwebengine:5[widgets] )"
DEPEND="dev-libs/boost:=
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
	)"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules:0"

DEPEND+=" test? ( dev-cpp/gtest dev-qt/qttest )"

DOCS=( AUTHORS ChangeLog README.md )

REQUIRED_USE="|| ( gui server monolithic )
	crypt? ( || ( server monolithic ) )
	kde? ( dbus spell )
	ldap? ( || ( server monolithic ) )
	postgres? ( || ( server monolithic ) )
	snorenotify? ( || ( gui monolithic ) )
	spell? ( || ( gui monolithic ) )
	syslog? ( || ( server monolithic ) )"

PATCHES=(
	"${FILESDIR}/quassel-0.14.0-cxxflags.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DUSE_CCACHE=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DEMBED_DATA=OFF
		-DWITH_WEBKIT=OFF
		-DWITH_BUNDLED_ICONS=$(usex bundled-icons)
		-DWITH_KDE=$(usex kde)
		-DWITH_LDAP=$(usex ldap)
		-DWANT_MONO=$(usex monolithic)
		-DWITH_OXYGEN_ICONS=$(usex oxygen)
		-DWANT_CORE=$(usex server)
		-DWITH_WEBENGINE=$(usex urlpreview)
		-DWANT_QTCLIENT=$(usex gui)
	)

	if use gui || use monolithic ; then
		# We can't always pass these (avoid "unused" warning)
		# bug #830708
		mycmakeargs+=(
			$(cmake_use_find_package dbus dbusmenu-qt5)
			$(cmake_use_find_package dbus Qt5DBus)
			$(cmake_use_find_package snorenotify LibsnoreQt5)
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
		elog "is available at http://bugs.quassel-irc.org/projects/quassel-irc/wiki/Client-Core_SSL_support."
	fi

	if use server ; then
		einfo "If you want to generate SSL certificate remember to run:"
		einfo "	emerge --config =${CATEGORY}/${PF}"
	fi

	if use server || use monolithic ; then
		einfo "Quassel can use net-misc/oidentd package if installed on your system."
		einfo "Consider installing it if you want to run quassel within identd daemon."
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
				-out "${QUASSEL_DIR}/quasselCert.pem"

			# Permissions for the key
			chown ${PN}:${PN} "${QUASSEL_DIR}/quasselCert.pem"
			chmod 400 "${QUASSEL_DIR}/quasselCert.pem"
		else
			einfo "Certificate \"${QUASSEL_DIR}/quasselCert.pem\" already exists."
			einfo "Remove it if you want to create new one."
		fi
	fi
}
