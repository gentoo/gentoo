# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV#9999} != ${PV} ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://code.videolan.org/videolan/libbluray.git"
else
	SRC_URI="https://downloads.videolan.org/pub/videolan/libbluray/${PV}/${P}.tar.bz2"
	KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
fi

inherit autotools java-pkg-opt-2 multilib-minimal

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="https://www.videolan.org/developers/libbluray.html"

LICENSE="LGPL-2.1"
SLOT="0/2"
IUSE="aacs bdplus +fontconfig java +truetype utils +xml"

COMMON_DEPEND="
	>=dev-libs/libudfread-1.1.0[${MULTILIB_USEDEP}]
	aacs? ( >=media-libs/libaacs-0.6.0[${MULTILIB_USEDEP}] )
	bdplus? ( media-libs/libbdplus[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}] )
	xml? ( >=dev-libs/libxml2-2.9.1-r4:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${COMMON_DEPEND}
	java? (
		>=dev-java/ant-1.10.14-r3:0
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
	"${FILESDIR}/libbluray-1.3.4-min-java.patch"
	"${FILESDIR}"/${PN}-jars.patch
	"${FILESDIR}"/${PN}-1.3.4-fix-libudfread-option.patch
)

DOCS=( ChangeLog README.md )

src_prepare() {
	default

	cat > src/libbluray/bdj/build.properties <<-EOF
		java_version_asm=1.8
		java_version_bdj=1.8
	EOF

	eautoreconf
}

multilib_src_configure() {
	# bug #621992
	use java || unset JDK_HOME

	local myeconfargs=(
		--disable-optimizations
		--with-external-libudfread
		$(multilib_native_use_enable utils examples)
		$(multilib_native_use_enable java bdjava-jar)
		$(use_with fontconfig)
		$(use_with truetype freetype)
		$(use_with xml libxml2)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	multilib_is_native_abi || return

	use utils &&
		find .libs/ -type f -executable ! -name "${PN}.*" \
			 $(use java || echo '! -name bdj_test') -exec dobin {} +

	use java && java-pkg_regjar "${ED}"/usr/share/${PN}/lib/*.jar
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
