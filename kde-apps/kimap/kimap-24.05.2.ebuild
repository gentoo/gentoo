# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Library for interacting with IMAP servers"
HOMEPAGE="https://api.kde.org/kdepim/kimap/html/index.html"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RDEPEND="
	dev-libs/cyrus-sasl
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
"
# TODO: Convince upstream not to install stuff with tests
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[network] )
"

src_test() {
	# tests cannot be run in parallel #605586
	local myctestargs=(
		-j1
	)
	ecm_src_test
}
