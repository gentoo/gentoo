# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KDE_ORG_NAME="plasma-workspace"
KFMIN=5.64.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Workspace library to interact with the Plasma session manager"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE=""

COMMON_DEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-plasma/kscreenlocker-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
"
DEPEND="${COMMON_DEPEND}
	>=kde-plasma/kwin-${PVCUT}:5
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/plasma-workspace-5.14.2:5
"

S="${S}/${PN}"

PATCHES=( "${FILESDIR}/${PN}-5.16.80-standalone.patch" )

src_prepare() {
	# delete colliding libkworkspace translations, let ecm_src_prepare do its magic
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find ../po -type f -name "*po" -and -not -name "libkworkspace*" -delete || die
		rm -rf po/*/docs || die
		cp -a ../po ./ || die
	fi
	ecm_src_prepare
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		cat >> CMakeLists.txt <<- _EOF_ || die
			ki18n_install(po)
		_EOF_
	fi

	sed -e "/set/s/GENTOO_PV/$(ver_cut 1-3)/" \
		-i CMakeLists.txt || die "Failed to prepare CMakeLists.txt"
}
