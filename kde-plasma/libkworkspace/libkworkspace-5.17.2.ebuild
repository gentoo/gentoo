# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
KMNAME="plasma-workspace"
inherit kde5

DESCRIPTION="Workspace library to interact with the Plasma session manager"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep plasma)
	$(add_plasma_dep kscreenlocker)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtx11extras)
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
"
DEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kwin)
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/plasma-workspace-5.14.2:5
"

S="${S}/${PN}"

PATCHES=( "${FILESDIR}/${PN}-5.16.80-standalone.patch" )

src_prepare() {
	# delete colliding libkworkspace translations, let kde5_src_prepare do its magic
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find ../po -type f -name "*po" -and -not -name "libkworkspace*" -delete || die
		rm -rf po/*/docs || die
		cp -a ../po ./ || die
	fi
	kde5_src_prepare
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		cat >> CMakeLists.txt <<- _EOF_ || die
			ki18n_install(po)
		_EOF_
	fi

	sed -e "/set/s/GENTOO_PV/$(ver_cut 1-3)/" \
		-i CMakeLists.txt || die "Failed to prepare CMakeLists.txt"
}
