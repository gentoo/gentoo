# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

SUPPORTP="${PN}-support-1.3"
DESCRIPTION="A gaming server for Battle.Net compatible clients"
HOMEPAGE="https://sourceforge.net/projects/pvpgn.berlios/"
SRC_URI="mirror://sourceforge/pvpgn.berlios/${PN}-${PV/_/}.tar.bz2
	mirror://sourceforge/pvpgn.berlios/${SUPPORTP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="mysql postgres"

DEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql[server] )"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}/${P}-fhs.patch"
}

src_configure() {
	cd src
	# everything in GAMES_BINDIR (bug #63071)
	egamesconf \
		--sbindir="${GAMES_BINDIR}" \
		$(use_with mysql) \
		$(use_with postgres pgsql)
}

src_compile() {
	emake -C src
}

src_install() {
	local f

	dodoc README README.DEV CREDITS BUGS TODO UPDATE version-history.txt
	docinto docs
	dodoc docs/*

	emake -C src DESTDIR="${D}" install

	insinto "${GAMES_DATADIR}/${PN}"
	doins "${WORKDIR}/${SUPPORTP}/"*

	# GAMES_USER_DED here instead of GAMES_USER (bug #65423)
	for f in bnetd d2cs d2dbs ; do
		newinitd "${FILESDIR}/${PN}.rc" ${f}
		sed -i \
				-e "s:NAME:${f}:g" \
				-e "s:GAMES_BINDIR:${GAMES_BINDIR}:g" \
				-e "s:GAMES_USER:${GAMES_USER_DED}:g" \
				-e "s:GAMES_GROUP:${GAMES_GROUP}:g" \
				"${D}/etc/games/${PN}/${f}.conf" \
				"${D}/etc/init.d/${f}" || die
	done

	keepdir $(find "${D}${GAMES_STATEDIR}"/${PN} -type d -printf "${GAMES_STATEDIR}/${PN}/%P ") "${GAMES_STATEDIR}"/${PN}/log
	prepgamesdirs

	chown -R ${GAMES_USER_DED}:${GAMES_GROUP} "${D}${GAMES_STATEDIR}/${PN}"
	fperms 0775 "${GAMES_STATEDIR}/${PN}/log"
	fperms 0770 "${GAMES_STATEDIR}/${PN}"
}

pkg_postinst() {
	games_pkg_postinst

	elog "If this is a first installation you need to configure the package by"
	elog "editing the configuration files provided in ${GAMES_SYSCONFDIR}/${PN}"
	elog "Also you should read the documentation in /usr/share/docs/${PF}"
	elog
	elog "If you are upgrading you MUST read UPDATE in /usr/share/docs/${PF}"
	elog "and update your configuration accordingly."
	if use mysql ; then
		elog
		elog "You have enabled MySQL storage support. You will need to edit"
		elog "bnetd.conf to use it. Read README.storage from the docs directory."
	fi
	if use postgres ; then
		elog
		elog "You have enabled PostgreSQL storage support. You will need to edit"
		elog "bnetd.conf to use it. Read README.storage from the docs directory."
	fi
}
