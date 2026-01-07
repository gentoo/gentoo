# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.0.0
inherit cmake java-pkg-2 optfeature toolchain-funcs xdg

DESCRIPTION="Custom, open source Minecraft launcher"
HOMEPAGE="https://prismlauncher.org/ https://github.com/PrismLauncher/PrismLauncher"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PrismLauncher/PrismLauncher"
	EGIT_SUBMODULES=( '*' '-libraries/filesystem' )
else
	MY_PN="PrismLauncher"
	# use vendored tarball to avoid dealing with submodules directly
	SRC_URI="
		https://github.com/PrismLauncher/PrismLauncher/releases/download/${PV}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="~amd64 ~arm64"
fi

# GPL-3 for PolyMC (PrismLauncher is forked from it) and Prism itself
# Apache-2.0 for MultiMC (PolyMC is forked from it)
# LGPL-3+ for libnbtplusplus
# rest of its libs: https://github.com/PrismLauncher/PrismLauncher/tree/develop/libraries
LICENSE="Apache-2.0 BSD BSD-2 GPL-2+ GPL-3 ISC LGPL-2.1+ LGPL-3+"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

# Required at both build time and runtime
COMMON_DEPEND="
	app-arch/libarchive:=
	app-text/cmark:=
	dev-cpp/tomlplusplus
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,gui,network,widgets,xml(+)]
	>=dev-qt/qtnetworkauth-${QTMIN}:6
	games-util/gamemode
	media-gfx/qrencode:=
	virtual/zlib:=
"
# gulrak-filesystem dependency is only needed at build time, because we don't
# actually use it on Linux, only on legacy macOS. Still, we need it present at
# build time to appease CMake, and having it like this makes it easier to
# maintain than patching the CMakeLists file directly.
# max jdk-25 for bug #968411
DEPEND="${COMMON_DEPEND}
	dev-cpp/gulrak-filesystem
	media-libs/libglvnd
	<virtual/jdk-26:*
"
# QtSvg imageplugin needed at runtime for svg icons, via QIcon.
# At runtime we don't depend on JDK, only JRE
# And we need more than just the GL headers
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:6
	>=virtual/jre-1.8.0:*
	virtual/opengl
"
BDEPEND="
	app-text/scdoc
	>=kde-frameworks/extra-cmake-modules-6.0.0:*
	virtual/pkgconfig
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
		eapply "${FILESDIR}/${PN}-9.1-openjdk21.patch"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr"
		# Resulting binary is named prismlauncher
		-DLauncher_APP_BINARY_NAME="${PN}"
		-DLauncher_BUILD_PLATFORM="Gentoo"
		-DLauncher_QT_VERSION_MAJOR=6

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

	optfeature "built-in MangoHud support (available in GURU overlay)" games-util/mangohud
	optfeature "built-in Feral Gamemode support" games-util/gamemode
}
