# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.7.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Powerful flashcard and vocabulary learning program"
HOMEPAGE="https://apps.kde.org/kwordquiz/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-libs/kirigami-addons-0.9.0:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-apps/libkeduvocdocument-${PVCUT}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
"
RDEPEND="${DEPEND}"
