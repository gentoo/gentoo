# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools java-pkg-opt-2 multilib-minimal

if [[ ${PV#9999} != ${PV} ]] ; then
	EGIT_REPO_URI="https://code.videolan.org/videolan/libbluray.git"
	inherit git-r3
else
	SRC_URI="https://downloads.videolan.org/pub/videolan/libbluray/${PV}/${P}.tar.bz2"
	KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86"
fi

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="https://www.videolan.org/developers/libbluray.html"

LICENSE="LGPL-2.1"
SLOT="0/2"
IUSE="aacs bdplus +fontconfig java +truetype utils +xml"

RDEPEND="
	dev-libs/libudfread[${MULTILIB_USEDEP}]
	aacs? ( >=media-libs/libaacs-0.6.0[${MULTILIB_USEDEP}] )
	bdplus? ( media-libs/libbdplus[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	java? ( >=virtual/jre-1.8:* )
	truetype? ( >=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}] )
	xml? ( >=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	java? ( >=virtual/jdk-1.8:* )
"
BDEPEND="
	virtual/pkgconfig
	java? (
		dev-java/ant-core
		>=virtual/jdk-1.8:*
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-jars.patch
)

DOCS=( ChangeLog README.md )

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	# bug #621992
	use java || unset JDK_HOME

	ECONF_SOURCE="${S}" econf \
		--disable-optimizations \
		$(multilib_native_use_enable utils examples) \
		$(multilib_native_use_enable java bdjava-jar) \
		$(use_with fontconfig) \
		$(use_with truetype freetype) \
		$(use_with xml libxml2)
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
