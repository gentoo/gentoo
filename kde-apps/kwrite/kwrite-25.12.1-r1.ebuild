# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kate"
ECM_HANDBOOK="forceoff"
KFMIN=6.19.0
QTMIN=6.9.1
inherit ecm flag-o-matic gear.kde.org xdg

DESCRIPTION="Simple text editor based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/kwrite/"
PATCH="${KDE_ORG_NAME}-${PV}-fix-kio-binary-compat.patch"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PATCH}.xz"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	~kde-apps/kate-lib-${PV}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	virtual/libintl
"
RDEPEND="${DEPEND}
	>=kde-apps/kate-common-${PV}
"

PATCHES=( "${WORKDIR}/${PATCH}" )

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
	# these tests are run in kde-apps/kate-lib; don't build kio plugin
	cmake_comment_add_subdirectory -f apps/lib autotests io
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_addons=FALSE
		-DBUILD_kate=FALSE
	)

	# provided by kde-apps/kate-lib
	append-libs -lkateprivate

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# provided by kde-apps/kate-lib
	rm -v "${ED}"/usr/$(get_libdir)/libkateprivate.so.* || die
	rm -v "${ED}"/usr/bin/exec_inspect.sh || die
}
