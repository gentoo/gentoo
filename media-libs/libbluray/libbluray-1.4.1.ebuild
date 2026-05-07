# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV#9999} != ${PV} ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://code.videolan.org/videolan/libbluray.git"
else
	SRC_URI="https://downloads.videolan.org/pub/videolan/libbluray/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

inherit meson-multilib java-pkg-opt-2

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="https://www.videolan.org/developers/libbluray.html"

LICENSE="LGPL-2.1+"
SLOT="0/3"
IUSE="aacs bdplus +fontconfig static-libs +truetype utils +xml"

COMMON_DEPEND="
	>=dev-libs/libudfread-1.2.0:=[${MULTILIB_USEDEP}]
	aacs? ( >=media-libs/libaacs-0.6.0[${MULTILIB_USEDEP}] )
	bdplus? ( media-libs/libbdplus[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}] )
	xml? ( >=dev-libs/libxml2-2.9.1-r4:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${COMMON_DEPEND}
	java? (
		>=dev-java/ant-1.10.15:0
		>=virtual/jdk-1.8:*
	)
"
RDEPEND="
	${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1-jars.patch
)

src_prepare() {
	default

	if use java; then
		cat > src/libbluray/bdj/build.properties <<-EOF || die "build.properties"
			ant.build.javac.source=$(java-pkg_get-source)
			ant.build.javac.target=$(java-pkg_get-target)
			java_version_asm=1.8
			java_version_bdj=1.8
		EOF
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(multilib_native_usex static-libs both shared)

		-Denable_examples=false
		-Denable_devtools=false
		$(meson_native_use_bool utils enable_tools)
		$(meson_native_use_feature java bdj_jar)
		$(meson_feature fontconfig)
		$(meson_feature truetype freetype)
		$(meson_feature xml libxml2)
	)

	meson_src_configure
}

multilib_src_install() {
	meson_src_install

	multilib_is_native_abi || return

	use java && java-pkg_regjar "${ED}"/usr/share/${PN}/lib/*.jar
}
