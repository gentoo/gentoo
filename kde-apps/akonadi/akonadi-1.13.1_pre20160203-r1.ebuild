# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} = *_pre* ]]; then
	# KDE quickgit https certificate issue
	# COMMIT_ID="18ed37d89b8185ac15a8bfe245de8a88d17f2c64"
	# SRC_URI="https://quickgit.kde.org/?p=${PN}.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${P}.tar.gz"
	SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.gz"
	S="${WORKDIR}/${PN}"
else
	SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.bz2"
fi
inherit cmake-utils

DESCRIPTION="The server part of Akonadi"
HOMEPAGE="https://pim.kde.org/akonadi"

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+mysql postgres sqlite test"

REQUIRED_USE="|| ( sqlite mysql postgres )"

CDEPEND="
	dev-libs/boost:=
	>=dev-qt/qtcore-4.8.5:4
	>=dev-qt/qtdbus-4.8.5:4
	>=dev-qt/qtgui-4.8.5:4
	>=dev-qt/qtsql-4.8.5:4[mysql?,postgres?]
	>=dev-qt/qttest-4.8.5:4
	x11-misc/shared-mime-info
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${CDEPEND}
	dev-libs/libxslt
	>=dev-util/automoc-0.9.88
	test? ( sys-apps/dbus )
"
RDEPEND="${CDEPEND}
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql[server] )
"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-1.13.0-mysql56-crash.patch"
	"${FILESDIR}/${PN}-1.13.1-mysql.conf.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -lt 4 ]] || \
			( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) \
			&& die "Sorry, but gcc-4.6 and earlier won't work (see bug #520102)."
	fi
}

pkg_setup() {
	# Set default storage backend in order: MySQL, SQLite PostgreSQL
	# reverse driver check to keep the order
	if use postgres; then
		DRIVER="QPSQL"
		AVAILABLE+=" ${DRIVER}"
	fi

	if use sqlite; then
		DRIVER="QSQLITE3"
		AVAILABLE+=" ${DRIVER}"
	fi

	if use mysql; then
		DRIVER="QMYSQL"
		AVAILABLE+=" ${DRIVER}"
	fi

	# Notify about MySQL is recommend by upstream
	if use sqlite || has_version "<${CATEGORY}/${P}[sqlite]"; then
		ewarn
		ewarn "We strongly recommend you change your Akonadi database backend to MySQL in your"
		ewarn "user configuration. This is the backend recommended by KDE upstream. PostgreSQL"
		ewarn "is also known to work very well but requires manual dump and import on major"
		ewarn "upgrades of the DB."
		ewarn "You can select the backend in your ~/.config/akonadi/akonadiserverrc."
		ewarn "Available drivers are:${AVAILABLE}"
		ewarn
	fi
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_QSQLITE_IN_QT_PREFIX=ON
		-DWITH_SOPRANO=FALSE
		-DAKONADI_BUILD_TESTS=$(usex test)
		-DAKONADI_BUILD_QSQLITE=$(usex sqlite)
		-DQT5_BUILD=OFF
	)

	cmake-utils_src_configure
}

src_test() {
	export $(dbus-launch)
	cmake-utils_src_test
}

src_install() {
	# Who knows, maybe it accidentally fixes our permission issues
	cat <<-EOF > "${T}"/akonadiserverrc
[%General]
Driver=${DRIVER}
EOF
	insinto /usr/share/config/akonadi
	doins "${T}"/akonadiserverrc

	cmake-utils_src_install
}

pkg_postinst() {
	elog "${DRIVER} has been set as your default akonadi storage backend."
	elog "You can override it in your ~/.config/akonadi/akonadiserverrc."
	elog "Available drivers are: ${AVAILABLE}"
}
