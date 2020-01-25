# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Library for interacting with IMAP servers"
HOMEPAGE="https://api.kde.org/kdepim/kimap/html/index.html"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	dev-libs/cyrus-sasl
"
# TODO: Convince upstream not to install stuff with tests
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qtnetwork-${QTMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"

src_test() {
	# tests cannot be run in parallel #605586
	local myctestargs=(
		-j1
	)
	ecm_src_test
}
