# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="A command-line based binary newsgrabber supporting .nzb files"
HOMEPAGE="https://nzbget.com/"
SRC_URI="https://github.com/nzbgetcom/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="gnutls ncurses +parcheck ssl test zlib"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/boost:=
	dev-libs/libxml2:=
	ncurses? ( sys-libs/ncurses:0= )
	ssl? (
		gnutls? (
			net-libs/gnutls:=
			dev-libs/nettle:=
		)
		!gnutls? ( dev-libs/openssl:0=[-bindist(-)] )
	)
	zlib? ( sys-libs/zlib:= )"
RDEPEND="
	${DEPEND}
	acct-user/nzbget
	acct-group/nzbget
"
BDEPEND="
	test? (
		|| (
			app-arch/rar
			app-arch/unrar
		)
	)
	virtual/pkgconfig
"

DOCS=( ChangeLog.md README.md nzbget.conf )

PATCHES=(
	"${FILESDIR}/${P}-fix-allocah.patch"
)

src_prepare() {
	# Do not install a configuration file in /usr/etc
	sed -i '\:install(FILES ${CMAKE_BINARY_DIR}/nzbget.conf DESTINATION ${CMAKE_INSTALL_PREFIX}/etc):d' cmake/install.cmake || die
	cmake_src_prepare

	sed -i 's:^ScriptDir=.*:ScriptDir=/usr/share/nzbget/ppscripts:' nzbget.conf || die

	sed \
		-e 's:^MainDir=.*:MainDir=/var/lib/nzbget:' \
		-e 's:^LogFile=.*:LogFile=/var/log/nzbget/nzbget.log:' \
		-e 's:^WebDir=.*:WebDir=/usr/share/nzbget/webui:' \
		-e 's:^ConfigTemplate=.*:ConfigTemplate=/usr/share/nzbget/nzbget.conf:' \
		-e 's:^DaemonUsername=.*:DaemonUsername=nzbget:' \
		nzbget.conf > nzbgetd.conf || die
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_CURSES=$(usex !ncurses)
		-DDISABLE_PARCHECK=$(usex !parcheck)
		-DDISABLE_TLS=$(usex !ssl)
		-DDISABLE_GZIP=$(usex !zlib)
		-DUSE_OPENSSL=$(usex !gnutls)
		-DUSE_GNUTLS=$(usex gnutls)
		-DENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc
	doins nzbget.conf
	doins nzbgetd.conf

	keepdir /var/log/nzbget

	newinitd "${FILESDIR}"/nzbget.initd-r1 nzbget
	newconfd "${FILESDIR}"/nzbget.confd nzbget
	systemd_dounit "${FILESDIR}"/nzbget.service
}

pkg_preinst() {
	fowners nzbget:nzbget /var/log/nzbget
	fperms 750 /var/log/nzbget

	fowners nzbget:nzbget /etc/nzbgetd.conf
	fperms 640 /etc/nzbgetd.conf
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog
		elog "Please add users that you want to be able to use the system-wide"
		elog "nzbget daemon to the nzbget group. To access the daemon, run nzbget"
		elog "with the --configfile /etc/nzbgetd.conf option."
		elog
	fi
}
