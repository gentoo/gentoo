# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

SUPPORTP="${PN}-support-1.3"
DESCRIPTION="A gaming server for Battle.Net compatible clients"
HOMEPAGE="https://pvpgn.pro"
SRC_URI="https://github.com/pvpgn/pvpgn-server/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-server-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql odbc postgres sqlite"

DEPEND="
	mysql? ( dev-db/mysql-connector-c:0= )
	odbc? ( dev-db/libiodbc )
	postgres? ( dev-db/postgresql:*[server] )
	sqlite? ( dev-db/sqlite )
"
RDEPEND="
	${DEPEND}
	acct-user/pvpgn
	acct-group/pvpgn
"

PATCHES=(
	#"${FILESDIR}"/${PN}-1.8.5-fhs.patch
	"${FILESDIR}"/${PN}-1.99.7.2.1-path.patch
)

src_prepare() {
	sed -i \
		-e 's/-O3 -march=native -mtune=native//' \
		-e 's/-stdlib=libc++//' \
		CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	tc-export CC

	local mycmakeargs=(
		-DWITH_MYSQL=$(usex mysql)
		-DWITH_ODBC=$(usex odbc)
		-DWITH_PGSQL=$(usex postgres)
		-DWITH_SQLITE3=$(usex sqlite)
	)

	cmake_src_configure
}

src_install() {
	local f

	cmake_src_install

	dolib.so "${BUILD_DIR}"/src/compat/libcompat.so
	dolib.so "${BUILD_DIR}"/src/common/libcommon.so

	# Was: "GAMES_USER_DED here instead of GAMES_USER (bug #65423)"
	for f in bnetd d2cs d2dbs ; do
		newinitd "${FILESDIR}/${PN}.rc" ${f}

		sed -i \
				-e "s:NAME:${f}:g" \
				-e "s:GAMES_BINDIR:/usr/bin:g" \
				-e "s:GAMES_USER:pvpgn:g" \
				-e "s:GAMES_GROUP:pvpgn:g" \
				"${ED}/etc/${PN}/${f}.conf" \
				"${ED}/etc/init.d/${f}" || die
	done

	keepdir $(find "${ED}/var/lib"/${PN} -type d -printf "/var/lib/${PN}/%P ") /var/lib/${PN}/log

	keepdir /var/pvpgn/{bnmail,chanlogs,charinfo,charsave,clans,ladders}
	keepdir /var/pvpgn/{reports,status,teams,userlogs,users,userscdb}
	keepdir /var/pvpgn/bak/char{info,save}

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
