# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm frameworks.kde.org

DESCRIPTION="Address book API based on KDE Frameworks"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	=kde-frameworks/kcodecs-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtdeclarative-${QTMIN}:5 )
"

src_test() {
	# bug #566648 (access to /dev/dri/card0 denied)
	# bug #838502 (again some Qt translations loading related err...)
	local myctestargs=(
		-E "(kcontacts-addresstest|kcontacts-picturetest)"
	)
	ecm_src_test
}
