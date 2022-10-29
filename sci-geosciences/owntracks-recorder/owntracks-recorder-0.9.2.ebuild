# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3..4} )

inherit lua-single prefix systemd toolchain-funcs

MY_PN="ot-recorder"
DESCRIPTION="Stores and accesses location data published by the OwnTracks apps"
HOMEPAGE="https://owntracks.org"
SRC_URI="https://github.com/${PN/-//}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="crypt +http greenwich kill lua +mqtt +ping +tours"

REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	tours? ( http )
"

IDEPEND="
	acct-group/owntracks
	acct-user/owntracks
"

DEPEND="
	dev-db/lmdb:=
	dev-libs/libconfig:=
	net-misc/curl
	crypt? ( dev-libs/libsodium:= )
	lua? ( ${LUA_DEPS} )
	mqtt? ( app-misc/mosquitto )
	tours? ( sys-apps/util-linux )
"

RDEPEND="
	${IDEPEND}
	${DEPEND}
"

BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${P#*-}"

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	hprefixify etc/${MY_PN}.service
	mv $(prefixify_ro config.mk.in) config.mk || die
}

src_configure() {
	myconf=(
		WITH_MQTT=$(usex mqtt)
		WITH_PING=$(usex ping)
		WITH_LUA=$(usex lua)
		WITH_ENCRYPT=$(usex crypt)
		WITH_KILL=$(usex kill)
		WITH_HTTP=$(usex http)
		WITH_TOURS=$(usex tours)
		WITH_GREENWICH=$(usex greenwich)

		CC="$(tc-getCC)"
		CPP="$(tc-getCPP)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		INSTALLDIR="${EPREFIX}/usr"
		STORAGEDEFAULT="${EPREFIX}/var/db/${MY_PN}"
		DOCROOT="${EPREFIX}/var/www/${MY_PN}/htdocs"
		CONFIGFILE="${EPREFIX}/etc/${MY_PN}.conf"

		# The .pc file currently hardcodes "lib".
		MOSQUITTO_LIBS=-lmosquitto

		# Allow further customisation by users.
		"${OTR_CONF[@]}"
	)

	use lua && myconf+=(
		LUA_CFLAGS="$(lua_get_CFLAGS)"
		LUA_LIBS="$(lua_get_LIBS)"
	)
}

src_compile() {
	emake "${myconf[@]}"
}

src_install() {
	emake install "${myconf[@]}" DESTDIR="${ED}"
	dodoc *.md doc/*.md

	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}
	systemd_dounit etc/${MY_PN}.service

	keepdir /var/db/${MY_PN}
}

pkg_preinst() {
	fowners owntracks:owntracks /var/db/${MY_PN}
	fperms 750 /var/db/${MY_PN}

	fowners root:owntracks /etc/${MY_PN}.conf
	fperms 0640 /etc/${MY_PN}.conf
}
