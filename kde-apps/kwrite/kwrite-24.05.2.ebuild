# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kate"
ECM_HANDBOOK="optional"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm flag-o-matic gear.kde.org

DESCRIPTION="Simple text editor based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/kwrite/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	~kde-apps/kate-lib-${PV}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	virtual/libintl
"
DEPEND="${RDEPEND}"

src_prepare() {
	ecm_src_prepare

	# these tests are run in kde-apps/kate-lib
	cmake_run_in apps/lib cmake_comment_add_subdirectory autotests

	# delete colliding kate translations
	find po -type f -name "*po" -and -not -name "kwrite*" -delete || die
	rm -rf po/*/docs/kate* || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_addons=FALSE
		-DBUILD_kate=FALSE
	)
	use handbook && mycmakeargs+=( -DBUILD_katepart=FALSE )

	# provided by kde-apps/kate-lib
	append-libs -lkateprivate

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# provided by kde-apps/kate-lib
	rm -v "${ED}"/usr/$(get_libdir)/libkateprivate.so.* || die
}
