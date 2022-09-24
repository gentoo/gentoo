# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

MY_PV=${PV/_pre/-r}
MY_P=${PN}-${PV/_pre/-testing-r}

DESCRIPTION="A command-line based binary newsgrabber supporting .nzb files"
HOMEPAGE="https://nzbget.net/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}-src.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${PV/_pre*/-testing}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="debug gnutls ncurses +parcheck ssl test zlib"
RESTRICT="!test? ( test )"

DEPEND="
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

DOCS=( ChangeLog README nzbget.conf )

PATCHES=(
	# https://bugs.gentoo.org/805896
	# https://github.com/nzbget/nzbget/pull/793
	"${FILESDIR}/${P}-openssl-3.patch"
)

src_prepare() {
	default
	eautoreconf

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
	local myconf=(
		$(use_enable debug)
		$(use_enable ncurses curses)
		$(use_enable parcheck)
		$(use_enable ssl tls)
		$(use_enable zlib gzip)
		$(use_enable test tests)
		--with-tlslib=$(usex gnutls GnuTLS OpenSSL)
	)
	econf "${myconf[@]}"
}

src_test() {
	./nzbget --tests || die "Tests failed"
}

src_install() {
	default

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
