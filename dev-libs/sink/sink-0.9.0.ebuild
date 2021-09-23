# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.88.0
QTMIN=5.15.2
inherit ecm

DESCRIPTION="Data access layer handling synchronization, caching and indexing"
HOMEPAGE="https://kube-project.com"
SRC_URI="https://github.com/KDE/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64"

# qtgui is bogus but is required because something else in the deptree
# uses it as a public dependency but doesn't search for it properly
RDEPEND="
	>=app-crypt/gpgme-1.15.1[cxx,qt5]
	dev-db/lmdb:=
	dev-libs/flatbuffers:=
	>=dev-libs/kasync-0.3:5
	>=dev-libs/xapian-1.4.17:0=
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	kde-apps/kmime:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=net-libs/kdav2-0.4:5
	>=net-libs/kimap2-0.4:5
	net-misc/curl
	sys-libs/readline:0=
"
DEPEND="${RDEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
"

# fails to build
RESTRICT+=" test"

src_prepare() {
	ecm_src_prepare
	# tests are sprinkled all over the place, and examples are needed...
	# disabling tests disables installing 'hawd'... what a mess
	sed -e "/add_subdirectory(tests)/ s/^/#DONT/" \
		-i CMakeLists.txt examples/imapresource/CMakeLists.txt \
		examples/mail{transport,dir}resource/CMakeLists.txt \
		examples/ca{l,rd}davresource/CMakeLists.txt \
		|| die "Failed to disable tests everywhere"

	# Failed to build (at least with gcc-11) with std c++20. Switch to std c++17
	sed -i -e "s:CMAKE_CXX_STANDARD 20:CMAKE_CXX_STANDARD 17:"\
	-e "s:c++20:c++17:" CMakeLists.txt || die "Failed switch to std c++17"
}
