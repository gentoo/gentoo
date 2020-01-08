# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Data access layer handling synchronization, caching and indexing"
HOMEPAGE="https://kube-project.com"
SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64"

# qtgui is bogus but is required because something else in the deptree
# uses it as a public dependency but doesn't search for it properly
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-db/lmdb:=
	dev-libs/flatbuffers
	>=dev-libs/kasync-0.3:5
	>=dev-libs/xapian-1.4.4:0=
	kde-frameworks/extra-cmake-modules:5
	|| (
		kde-frameworks/kcalendarcore:5
		kde-apps/kcalcore:5
	)
	|| (
		kde-frameworks/kcontacts:5
		kde-apps/kcontacts:5
	)
	kde-frameworks/kcoreaddons:5
	kde-apps/kmime:5
	>=net-libs/kdav2-0.3:5
	>=net-libs/kimap2-0.3:5
	net-misc/curl
	sys-libs/readline:0=
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"

# fails to build
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Libgit2=ON
	)
	cmake_src_configure
}
