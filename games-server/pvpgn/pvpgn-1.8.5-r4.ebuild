# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

SUPPORTP="${PN}-support-1.3"
DESCRIPTION="A gaming server for Battle.Net compatible clients"
HOMEPAGE="https://sourceforge.net/projects/pvpgn.berlios/"
SRC_URI="mirror://sourceforge/pvpgn.berlios/${PN}-${PV/_/}.tar.bz2
	mirror://sourceforge/pvpgn.berlios/${SUPPORTP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres"

DEPEND="
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:*[server] )
"
RDEPEND="
	${DEPEND}
	acct-user/pvpgn
	acct-group/pvpgn
"

PATCHES=(
	"${FILESDIR}"/${P}-fhs.patch
)

src_configure() {
	cd src || die

	tc-export CC
	# Was: "everything in GAMES_BINDIR (bug #63071)"
	# Not anymore.
	econf \
		--sbindir="/usr/bin" \
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

	insinto /usr/share/${PN}
	doins "${WORKDIR}/${SUPPORTP}/"*

	# Was: "GAMES_USER_DED here instead of GAMES_USER (bug #65423)"
	for f in bnetd d2cs d2dbs ; do
		newinitd "${FILESDIR}/${PN}.rc" ${f}

		sed -i \
				-e "s:NAME:${f}:g" \
				-e "s:GAMES_BINDIR:/usr/bin:g" \
				-e "s:GAMES_USER:pvpgn:g" \
				-e "s:GAMES_GROUP:pvpgn:g" \
				"${D}/etc/${PN}/${f}.conf" \
				"${D}/etc/init.d/${f}" || die
	done

	keepdir $(find "${ED}/var/lib"/${PN} -type d -printf "/var/lib/${PN}/%P ") /var/lib/${PN}/log

	chown -R pvpgn:pvpgn "${ED}/var/lib/${PN}" || die
	fperms 0775 "/var/lib/${PN}/log"
	fperms 0770 "/var/lib/${PN}"
}

pkg_postinst() {
	elog "If this is a first installation you need to configure the package by"
	elog "editing the configuration files provided in /etc/${PN}"
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
