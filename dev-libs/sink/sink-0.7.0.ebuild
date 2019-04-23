# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="false" # build breaks otherwise. tests not isolated.
inherit kde5

DESCRIPTION="Data access layer handling synchronization, caching and indexing"
SRC_URI="https://github.com/KDE/sink/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE=""

# qtgui is bogus but is required because something else in the deptree
# uses it as a public dependency but doesn't search for it properly
RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	dev-db/lmdb:=
	dev-libs/flatbuffers
	dev-libs/kasync
	>=dev-libs/xapian-1.4.4:0=
	net-libs/kdav2
	net-libs/kimap2
	net-misc/curl
	sys-libs/readline:0=
"
DEPEND="${RDEPEND}
	$(add_qt_dep qtconcurrent)
"

# fails to build
RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare
	# FIXME: sink is useless without its 'examples'. Workaround our eclass
	sed -i -e "/add_subdirectory(examples)/ s/#DONOTCOMPILE //" \
		CMakeLists.txt || die "Failed to fix CMakeLists.txt"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Libgit2=ON
	)
	kde5_src_configure
}
