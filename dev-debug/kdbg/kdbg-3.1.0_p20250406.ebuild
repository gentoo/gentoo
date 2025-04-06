# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="78450aec94de5c2c5e07f9a448f454ebe39e4fc0"
PATCHSET="${P}-patchset.tar.xz"
ECM_HANDBOOK="true"
KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm

DESCRIPTION="Graphical debugger interface"
HOMEPAGE="https://www.kdbg.org/"
SRC_URI="https://github.com/j6t/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	dev-debug/gdb
"

# Patchset containing queued up upstream MRs, in order:
# https://github.com/j6t/kdbg/pull/48 (only partially picked)
# https://github.com/j6t/kdbg/commit/2e5de789 (Switch to KX11Extras)
# https://github.com/j6t/kdbg/pull/49 (Cast to QChar)
# https://github.com/j6t/kdbg/pull/50
PATCHES=( "${WORKDIR}"/${PATCHSET/.tar.xz/} )

src_prepare() {
	ecm_src_prepare
	# TODO: raising ECM leads to many more deprecations erroring out:
	sed -e "/^find_package(ECM/ s/\${KF_MIN_VERSION} //" -i CMakeLists.txt || die
	if ! use handbook; then
		cmake_run_in kdbg cmake_comment_add_subdirectory doc
	fi
}
