# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ $PV = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI=( "git://anongit.kde.org/akonadi" )
	SRC_URI=""
	KEYWORDS="amd64 ppc"
else
	SRC_URI="mirror://kde/stable/${PN/-server/}/src/${P/-server/}.tar.bz2"
	KEYWORDS="amd64 ~arm ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${P/-server/}"
fi

inherit cmake-utils ${scm_eclass}

DESCRIPTION="The server part of Akonadi"
HOMEPAGE="http://pim.kde.org/akonadi"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+mysql postgres +qt4 qt5 soprano sqlite test"

REQUIRED_USE="^^ ( qt4 qt5 ) || ( sqlite mysql postgres )"

CDEPEND="
	dev-libs/boost:=
	x11-misc/shared-mime-info
	qt4? (
		>=dev-qt/qtcore-4.8.5:4
		>=dev-qt/qtdbus-4.8.5:4
		>=dev-qt/qtgui-4.8.5:4
		>=dev-qt/qtsql-4.8.5:4[mysql?,postgres?]
		>=dev-qt/qttest-4.8.5:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsql:5[mysql?,postgres?]
		dev-qt/qttest:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		soprano? ( dev-libs/soprano[-qt4,qt5] )
	)
	soprano? ( dev-libs/soprano )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${CDEPEND}
	dev-libs/libxslt
	>=dev-util/automoc-0.9.88
	test? ( sys-apps/dbus )
"
RDEPEND="${CDEPEND}
	postgres? ( dev-db/postgresql[server] )
"

RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-mysql56-crash.patch" )

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
		ewarn "user configuration. This is the backend recommended by KDE upstream."
		ewarn "In particular, kde-base/kmail-4.10 does not work properly with the sqlite"
		ewarn "backend anymore."
		ewarn "You can select the backend in your ~/.config/akonadi/akonadiserverrc."
		ewarn "Available drivers are:${AVAILABLE}"
		ewarn
	fi
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_QSQLITE_IN_QT_PREFIX=ON
		$(cmake-utils_use test AKONADI_BUILD_TESTS)
		$(cmake-utils_use_with soprano)
		$(cmake-utils_use sqlite AKONADI_BUILD_QSQLITE)
		$(cmake-utils_use qt5 QT5_BUILD)
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
