# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils user systemd
DESCRIPTION="coturn TURN server project"
HOMEPAGE="https://github.com/${PN}/${PN}"

if [ ${PV} = 9999 ]; then
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
	DEPEND="dev-vcs/git"
#	S="${WORKDIR}/${PN}-master"
else
	KEYWORDS="~x86 ~amd64"
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
IUSE="mongodb mysql postgres redis sqlite"
RDEPEND="dev-libs/libevent[ssl]
	 dev-libs/openssl:*
	 mongodb? ( dev-libs/mongo-c-driver )
	 mysql? ( virtual/mysql )
	 postgres? ( dev-db/postgresql:* )
	 redis? ( dev-libs/hiredis )
	 sqlite? ( dev-db/sqlite )"
DEPEND="${RDEPEND}"

src_configure() {
	sed 's:#log-file=/var/tmp/turn.log:log-file=/var/log/turnserver.log:' \
	    -i "${S}/examples/etc/turnserver.conf"  || die "sed for logdir failed"
	sed 's:#simple-log:simple-log:' -i "${S}/examples/etc/turnserver.conf" \
	    || die "sed for simple-log failed"
	if ! use mongodb; then
		export TURN_NO_MONGO=yes
	fi
	if ! use mysql; then
		export TURN_NO_MYSQL=yes
	fi
	if ! use postgres; then
		export TURN_NO_PQ=yes
	fi
	if ! use redis; then
		export TURN_NO_HIREDIS=yes
	fi
	if ! use sqlite; then
		export TURN_NO_SQLITE=yes
	fi

	econf $(use_with sqlite)
}

src_install() {
	default
	newinitd "${FILESDIR}/turnserver.init" turnserver
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate.${PN}" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	enewgroup turnserver
	enewuser turnserver -1 -1 -1 turnserver
	elog "You need to copy /etc/turnserver.conf.default to"
	elog "/etc/turnserver.conf and do your settings there."
}
