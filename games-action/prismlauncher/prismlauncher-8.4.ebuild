# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake java-pkg-2 optfeature toolchain-funcs xdg

DESCRIPTION="A custom, open source Minecraft launcher"
HOMEPAGE="https://prismlauncher.org/ https://github.com/PrismLauncher/PrismLauncher"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="
		https://github.com/PrismLauncher/PrismLauncher
	"

	EGIT_SUBMODULES=(
		'*' '-libraries/cmark' '-libraries/extra-cmake-modules' '-libraries/filesystem' '-libraries/quazip'
		'-libraries/tomlplusplus' '-libraries/zlib'
	)
else
	MY_PN="PrismLauncher"

	# Let's use the vendored tarball to avoid dealing with the submodules directly
	SRC_URI="
		https://github.com/PrismLauncher/PrismLauncher/releases/download/${PV}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz
	"

	# The Prism's files are unpacked to ${WORKDIR}/PrismLauncher-${PV}
	S="${WORKDIR}/${MY_PN}-${PV}"

	KEYWORDS="~amd64 ~arm64"
fi

# GPL-3 for PolyMC (PrismLauncher is forked from it) and Prism itself
# Apache-2.0 for MultiMC (PolyMC is forked from it)
# LGPL-3+ for libnbtplusplus
# See the rest of PrismLauncher's libraries at https://github.com/PrismLauncher/PrismLauncher/tree/develop/libraries
LICENSE="Apache-2.0 BSD BSD-2 GPL-2+ GPL-3 ISC LGPL-2.1+ LGPL-3+"

SLOT="0"

IUSE="qt6 test"

RESTRICT="!test? ( test )"

MIN_QT_5_VERSION="5.12.0"
MIN_QT_6_VERSION="6.0.0"

QT_DEPS="
	!qt6? (
		>=dev-qt/qtconcurrent-${MIN_QT_5_VERSION}:5
		>=dev-qt/qtcore-${MIN_QT_5_VERSION}:5
		>=dev-qt/qtgui-${MIN_QT_5_VERSION}:5
		>=dev-qt/qtnetwork-${MIN_QT_5_VERSION}:5
		>=dev-qt/qttest-${MIN_QT_5_VERSION}:5
		>=dev-qt/qtwidgets-${MIN_QT_5_VERSION}:5
		>=dev-qt/qtxml-${MIN_QT_5_VERSION}:5
	)

	qt6? (
		>=dev-qt/qtbase-${MIN_QT_6_VERSION}:6[concurrent,gui,network,widgets,xml(+)]
		>=dev-qt/qt5compat-${MIN_QT_6_VERSION}:6
	)
"

# Required at both build-time and run-time
COMMON_DEPENDS="
	${QT_DEPS}

	!qt6? ( >=dev-libs/quazip-1.3:=[qt5(+)] )
	 qt6? ( >=dev-libs/quazip-1.3:=[qt6(-)] )

	app-text/cmark:=
	dev-cpp/tomlplusplus
	sys-libs/zlib
"

BDEPEND="
	app-text/scdoc
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

# The gulrak-filesystem dependency is only needed at build time, because we don't actually use it on Linux,
# only on legacy macOS. Still, we need it present at build time to appease CMake, and having it like this
# makes it easier to maintain than patching the CMakeLists file directly.
DEPEND="
	${COMMON_DEPENDS}
	dev-cpp/gulrak-filesystem
	media-libs/libglvnd
	>=virtual/jdk-1.8.0:*
"

# QtSvg imageplugin needed at runtime for svg icons. Its used via QIcon.
# At run-time we don't depend on JDK, only JRE
# And we need more than just the GL headers
RDEPEND="
	${COMMON_DEPENDS}

	!qt6? ( >=dev-qt/qtsvg-${MIN_QT_5_VERSION}:5 )
	 qt6? ( >=dev-qt/qtsvg-${MIN_QT_6_VERSION}:6 )

	>=virtual/jre-1.8.0:*
	virtual/opengl
"

src_prepare() {
	cmake_src_prepare

	local java="$(java-config -f)"
	local java_version=${java//[^0-9]/}
	if [[ ${java_version} -ge 20 ]]; then
		elog "Java 20 and up has dropped binary compatibility with java 7."
		elog "${PN} is being compiled with java ${java_version}."
		elog "The sources will be patched to build binary compatible with"
		elog "java 8 instead of java 7. This may cause issues with very old"
		elog "Minecraft versions and/or older forge versions."
		elog
		elog "If you experience any problems, install an older java compiler"
		elog "and select it with \"eselect java\", then recompile ${PN}."
		eapply "${FILESDIR}/${PN}-8.2-openjdk21.patch"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr"
		# Resulting binary is named prismlauncher
		-DLauncher_APP_BINARY_NAME="${PN}"
		-DLauncher_BUILD_PLATFORM="Gentoo"
		-DLauncher_QT_VERSION_MAJOR=$(usex qt6 6 5)

		-DENABLE_LTO=$(tc-is-lto)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst

	# Original issue: https://github.com/PolyMC/PolyMC/issues/227
	optfeature "old Minecraft (<= 1.12.2) support" x11-apps/xrandr

	optfeature "built-in MangoHud support" games-util/mangohud
	optfeature "built-in Feral Gamemode support" games-util/gamemode
}
