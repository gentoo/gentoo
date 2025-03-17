# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
ECM_HANDBOOK="optional"
KDE_ORG_COMMIT="a9741c3e17a9ee81331c5dab4a2d030e4e76b2fa"
PATCHSET="${P}-patchset"
inherit ecm kde.org

DESCRIPTION="Multiple information organizer - a DropDrawers clone"
HOMEPAGE="https://userbase.kde.org/BasKet https://invent.kde.org/utilities/basket"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="crypt git"

RDEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/karchive:5
	kde-frameworks/kcmutils:5
	kde-frameworks/kcodecs:5
	kde-frameworks/kcompletion:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kcrash:5
	kde-frameworks/kdbusaddons:5
	kde-frameworks/kfilemetadata:5
	kde-frameworks/kglobalaccel:5
	kde-frameworks/kguiaddons:5
	kde-frameworks/ki18n:5
	kde-frameworks/kiconthemes:5
	kde-frameworks/kio:5
	kde-frameworks/knotifications:5
	kde-frameworks/kparts:5
	kde-frameworks/kservice:5
	kde-frameworks/ktextwidgets:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kwindowsystem:5
	kde-frameworks/kxmlgui:5
	x11-libs/libX11
	crypt? ( >=app-crypt/gpgme-1.8.2:= )
	git? ( dev-libs/libgit2:= )
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"
BDEPEND="git? ( virtual/pkgconfig )"

PATCHES=( "${WORKDIR}/${PATCHSET}" )

src_prepare() {
	ecm_src_prepare

	if ! use test; then
		cmake_run_in src cmake_comment_add_subdirectory tests
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_PHONON=OFF
		-DENABLE_GPG=$(usex crypt)
		$(cmake_use_find_package git Libgit2)
	)
	ecm_src_configure
}
