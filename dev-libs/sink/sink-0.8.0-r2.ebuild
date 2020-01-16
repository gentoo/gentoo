# Copyright 1999-2020 Gentoo Authors
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
BDEPEND="
	kde-frameworks/extra-cmake-modules:5
"
RDEPEND="
	dev-db/lmdb:=
	dev-libs/flatbuffers
	>=dev-libs/kasync-0.3:5
	>=dev-libs/xapian-1.4.4:0=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	kde-apps/kmime:5
	kde-frameworks/kcalendarcore:5
	kde-frameworks/kcontacts:5
	kde-frameworks/kcoreaddons:5
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

src_prepare() {
	cmake_src_prepare
	# tests are sprinkled all over the place, and examples are needed...
	# disabling tests disables installing 'hawd'... what a mess
	sed -e "/add_subdirectory(tests)/ s/^/#DONT/" \
		-i CMakeLists.txt examples/imapresource/CMakeLists.txt \
		examples/mail{transport,dir}resource/CMakeLists.txt \
		examples/ca{l,rd}davresource/CMakeLists.txt \
		|| die "Failed to disable tests everywhere"
}
