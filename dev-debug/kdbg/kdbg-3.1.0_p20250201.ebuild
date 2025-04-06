# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="1ff0635e655de67d1c8b4c405595bd174a8e3622"
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
# https://github.com/j6t/kdbg/pull/48
# https://github.com/j6t/kdbg/pull/45
# https://github.com/j6t/kdbg/pull/46
# https://github.com/j6t/kdbg/pull/47
# TODO upstream:
# https://github.com/j6t/kdbg/commit/2e5de789 (Switch to KX11Extras)
# https://github.com/j6t/kdbg/commit/812dcfa1 (Cast to QChar)
# https://github.com/j6t/kdbg/pull/26/commits/21c7b20c (rebase: port to Qt6/KF6)
PATCHES=( "${WORKDIR}"/${PATCHSET/.tar.xz/} )

src_prepare() {
	ecm_src_prepare
	if ! use handbook; then
		cmake_run_in kdbg cmake_comment_add_subdirectory doc
	fi
}
