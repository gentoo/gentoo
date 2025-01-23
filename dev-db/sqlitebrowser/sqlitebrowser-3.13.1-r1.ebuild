# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Light GUI editor for SQLite databases"
HOMEPAGE="https://sqlitebrowser.org/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sqlitebrowser/sqlitebrowser.git"
else
	SRC_URI="https://github.com/sqlitebrowser/sqlitebrowser/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+ MPL-2.0"
SLOT="0"
IUSE="sqlcipher test"
RESTRICT="!test? ( test )"

RDEPEND="
	<app-editors/qhexedit2-0.8.10
	dev-db/sqlite:3
	<dev-libs/qcustomplot-2.1.1-r10
	>=dev-qt/qtcore-5.15.9:5
	>=dev-qt/qtgui-5.15.9:5
	>=dev-qt/qtnetwork-5.15.9:5[ssl]
	>=dev-qt/qtprintsupport-5.15.9:5
	>=dev-qt/qtwidgets-5.15.9:5
	>=dev-qt/qtxml-5.15.9:5
	>=x11-libs/qscintilla-2.14.1-r1:=[qt5(-)]
	sqlcipher? ( dev-db/sqlcipher )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtconcurrent-5.15.9:5
"
BDEPEND="
	>=dev-qt/linguist-tools-5.15.9:5
	test? ( >=dev-qt/qttest-5.15.9:5 )
"

DOCS=( images/ {BUILDING,CHANGELOG,README}.md )

PATCHES=( "${FILESDIR}/${P}-missing-include.patch" )

src_prepare() {
	cmake_src_prepare

	if ! use test; then
		sed -i CMakeLists.txt \
			-e "/find_package/ s/ Test//" \
			-e "/set/ s/ Qt5::Test//" \
			|| die "Cannot remove Qt Test from CMake dependencies"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTING=$(usex test)
		-DFORCE_INTERNAL_QSCINTILLA=OFF
		-DFORCE_INTERNAL_QCUSTOMPLOT=OFF
		-DFORCE_INTERNAL_QHEXEDIT=OFF
		-Dsqlcipher=$(usex sqlcipher)
	)

	# https://bugs.gentoo.org/855254
	append-flags -fno-strict-aliasing
	filter-lto

	cmake_src_configure
}

src_install() {
	[[ ${PV} == *9999* ]] && DOCS+=( SECURITY.md )
	cmake_src_install
}
