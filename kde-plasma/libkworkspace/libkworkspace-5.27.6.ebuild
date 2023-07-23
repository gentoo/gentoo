# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KDE_ORG_NAME="plasma-workspace"
KFMIN=5.106.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="Workspace library to interact with the Plasma session manager"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-plasma/kscreenlocker-${PVCUT}:5
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
"
DEPEND="${RDEPEND}
	>=kde-plasma/kwin-${PVCUT}:5
"

S="${S}/${PN}"

src_prepare() {
	# delete colliding libkworkspace translations, let ecm_src_prepare do its magic
	find ../po -type f -name "*po" -and -not -name "libkworkspace*" -delete || die
	rm -rf po/*/docs || die
	cp -a ../po ./ || die

	eapply "${FILESDIR}/${PN}-5.22.80-standalone.patch"
	sed -e "/set/s/GENTOO_PV/$(ver_cut 1-3)/" -i CMakeLists.txt || die
	cat >> CMakeLists.txt <<- _EOF_ || die
		ki18n_install(po)
	_EOF_

	ecm_src_prepare
}
