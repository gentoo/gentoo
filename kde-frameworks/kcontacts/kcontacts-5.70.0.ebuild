# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Address book API based on KDE Frameworks"
LICENSE="GPL-2+"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE=""

DEPEND="
	=kde-frameworks/kcodecs-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	>=dev-qt/qtgui-${QTMIN}:5
"
RDEPEND="${DEPEND}
	!kde-apps/kcontacts:5
	app-text/iso-codes
"

src_test() {
	# bug #566648 (access to /dev/dri/card0 denied), bug #625988
	local myctestargs=(
		-E "(kcontacts-addresstest|kcontacts-picturetest)"
	)
	ecm_src_test
}
