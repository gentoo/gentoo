# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FRAMEWORKS_MINIMAL="5.50.0"
QT_MINIMAL="5.11.1"
KDE_TEST="true"
KMNAME="plasma-workspace"
inherit kde5

DESCRIPTION="Workspace library to interact with the Plasma session manager"

KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep plasma)
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
	!kde-plasma/libkworkspace:4
	!<kde-plasma/plasma-workspace-5.14.2:5
"

S="${S}/${PN}"

PATCHES=( "${FILESDIR}/${PN}-5.14.2-standalone.patch" )

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

	sed -e "/set/s/GENTOO_PV/${PV}/" \
		-e "/set/s/GENTOO_QT_MINIMAL/${QT_MINIMAL}/" \
		-e "/set/s/GENTOO_KF5_MINIMAL/${FRAMEWORKS_MINIMAL}/" \
		-i CMakeLists.txt || die "Failed to prepare CMakeLists.txt"
}
