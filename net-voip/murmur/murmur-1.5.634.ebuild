# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic systemd readme.gentoo-r1 tmpfiles

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://wiki.mumble.info"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"

	# needed for the included 3rdparty license script,
	# even if these components may not be compiled in
	EGIT_SUBMODULES=(
		'-*'
		3rdparty/cmake-compiler-flags
		3rdparty/FindPythonInterpreter
		3rdparty/flag-icons
		3rdparty/minhook
		3rdparty/speexdsp
		3rdparty/tracy
	)
else
	MY_PN="mumble"
	if [[ "${PV}" == *_pre* ]] ; then
		MY_P="${MY_PN}-${PV}"
		SRC_URI="https://dev.gentoo.org/~concord/distfiles/${MY_P}.tar.xz"
		S="${WORKDIR}/${MY_P}"
	else
		MY_PV="${PV/_/-}"
		MY_P="${MY_PN}-${MY_PV}"
		SRC_URI="https://github.com/mumble-voip/mumble/releases/download/v${MY_PV}/${MY_P}.tar.gz"
		S="${WORKDIR}/${MY_PN}-${PV/_*}"
	fi
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+ice test zeroconf"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/murmur
	acct-user/murmur
	dev-cpp/ms-gsl
	>=dev-libs/openssl-1.0.0b:0=
	>=dev-libs/protobuf-2.2.0:=
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5[ssl]
	|| (
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtsql:5[mysql]
	)
	dev-qt/qtxml:5
	sys-apps/lsb-release
	>=sys-libs/libcap-2.15
	ice? ( dev-libs/Ice:= )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"

DEPEND="${RDEPEND}
	dev-libs/boost
	dev-qt/qttest:5
"
BDEPEND="
	acct-group/murmur
	acct-user/murmur
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
The default 'SuperUser' password will be written into the log file
when starting murmur for the first time.

If you want to manually set a password yourself, please execute:
su murmur -s /bin/bash -c 'mumble-server -ini /etc/murmur/mumble-server.ini -supw <pw>'

This will set the built-in 'SuperUser' password to '<pw>' when starting murmur.
"

src_prepare() {
	# Adjust default server settings to be correct for our default setup
	sed \
		-e 's:database=:database=/var/lib/murmur/database.sqlite:' \
		-e 's:;logfile=mumble-server.log:logfile=/var/log/murmur/murmur.log:' \
		-e 's:;pidfile=:pidfile=/run/murmur/murmur.pid:' \
		-i auxiliary_files/mumble-server.ini || die

	# Replace the default group and user _mumble-server with murmur
	grep -r -l _mumble-server auxiliary_files/ | xargs sed -i 's/_mumble-server/murmur/g' || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
		-Dbundled-gsl="OFF"
		-Dclient="OFF"
		-Dice="$(usex ice)"
		-DMUMBLE_INSTALL_SYSCONFDIR="/etc/murmur"
		-Dserver="ON"
		-DMUMBLE_INSTALL_SERVICEFILEDIR=$(systemd_get_systemunitdir)
		-DMUMBLE_INSTALL_SYSUSERSDIR=$(systemd_get_userunitdir)
		-DMUMBLE_INSTALL_TMPFILESDIR="/usr/lib/tmpfiles.d"
		-Dwarnings-as-errors="OFF"
		-Dzeroconf="$(usex zeroconf)"
	)
	if [[ "${PV}" != 9999 ]] ; then
		mycmakeargs+=( -DBUILD_NUMBER="$(ver_cut 3)" )
	fi

	# https://bugs.gentoo.org/832978
	# fix tests (and possibly runtime issues) on arches with unsigned chars
	append-cxxflags -fsigned-char

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc README.md

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/murmur.logrotate murmur

	# Copy over the initd file so we can modify it incase zeroconf support is on.
	cp "${FILESDIR}"/murmur.initd-r2 "${T}"/murmur.initd || die

	if use zeroconf; then
		sed -e 's:need:need avahi-daemon:' -i "${T}"/murmur.initd || die
	fi

	newinitd "${T}"/murmur.initd murmur
	newconfd "${FILESDIR}"/murmur.confd-r2 murmur

	keepdir /var/lib/murmur /var/log/murmur
	fowners -R murmur /var/lib/murmur /var/log/murmur
	fperms 750 /var/lib/murmur /var/log/murmur

	mv "${ED}"/etc/murmur/mumble-server.ini "${ED}"/etc/murmur/murmur.ini || die
	mv "${D}/$(systemd_get_systemunitdir)/mumble-server.service" \
		"${D}/$(systemd_get_systemunitdir)/murmur.service" || die
	sed -i 's|mumble-server\.ini|murmur.ini|' "${D}/$(systemd_get_systemunitdir)/murmur.service" || die

	readme.gentoo_create_doc
}

pkg_postinst() {
	tmpfiles_process mumble-server.conf
	readme.gentoo_print_elog

	if use zeroconf; then
		elog "To turn on the zeroconf functionality, you need to uncomment and"
		elog "change the 'bonjour=false' setting in mumble-server.ini to 'true'"
	fi
}
