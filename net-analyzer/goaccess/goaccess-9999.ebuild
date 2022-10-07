# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/allinurl/${PN}.git"

inherit autotools git-r3 optfeature systemd tmpfiles

DESCRIPTION="A real-time web log analyzer and interactive viewer in a terminal"
HOMEPAGE="https://goaccess.io"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="debug geoip geoipv2 getline ssl unicode"
REQUIRED_USE="geoipv2? ( geoip )"

RDEPEND="acct-group/goaccess
	acct-user/goaccess
	sys-libs/ncurses:=[unicode(+)?]
	geoip? (
		!geoipv2? ( dev-libs/geoip )
		geoipv2? ( dev-libs/libmaxminddb:0= )
	)
	ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Enable log-format, define log file and db path,
	# change path to GeoIP bases in config
	sed -i  -e '/log-format COMBINED/s/#//' \
		-e '/log-file/s/#//' \
		-e '/db-path/s|tmp|var/lib/goaccess|' \
		-e '/geoip-database/s|local/||' config/goaccess.conf \
		|| die "sed failed for goaccess.conf"

	eautoreconf
}

src_configure() {
	local myeconfargs=()
	readarray -t myeconfargs < <(
		use_enable debug
		use_enable geoip geoip "$(usex geoipv2 mmdb legacy)"
		use_enable unicode utf8
		use_with getline
		use_with ssl openssl
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/goaccess.initd goaccess
	newconfd "${FILESDIR}"/goaccess.confd goaccess
	systemd_dounit "${FILESDIR}"/goaccess.service
	newtmpfiles "${FILESDIR}"/goaccess.tmpfile goaccess.conf

	diropts -o goaccess -g goaccess -m 0700
	keepdir /var/lib/goaccess/db /var/log/goaccess
}

pkg_postinst() {
	optfeature "update GeoIP databases" net-misc/geoipupdate
	tmpfiles_process goaccess.conf
}
