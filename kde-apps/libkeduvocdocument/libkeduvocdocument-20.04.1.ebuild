# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KFMIN=5.70.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Library for reading/writing KVTML"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
"
RDEPEND="${DEPEND}"

src_prepare(){
	ecm_src_prepare

	if ! use test; then
		sed -e "/add_subdirectory(autotests)/ s/^/#DONT/" \
			-e "/add_subdirectory(tests)/ s/^/#DONT/" \
			-i keduvocdocument/CMakeLists.txt || die
	fi
}
