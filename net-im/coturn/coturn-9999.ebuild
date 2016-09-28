# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils user
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
}

pkg_postinst() {
	enewgroup turnserver
	enewuser turnserver -1 -1 -1 turnserver
	elog "Be aware that the default path for logfiles in coturn is /var/tmp!"
	elog "You should copy /etc/turnserver.conf.default to"
	elog "/etc/turnserver.conf and change not only the log option."
}
