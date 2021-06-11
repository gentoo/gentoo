# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ "${PV#9999}" != "${PV}" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://code.videolan.org/videolan/libbluray.git"
else
	KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86"
	SRC_URI="https://downloads.videolan.org/pub/videolan/libbluray/${PV}/${P}.tar.bz2"
fi

inherit autotools java-pkg-opt-2 flag-o-matic multilib-minimal

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="https://www.videolan.org/developers/libbluray.html"

LICENSE="LGPL-2.1"
SLOT="0/2"
IUSE="aacs bdplus +fontconfig java static-libs +truetype utils +xml"

COMMON_DEPEND="
	xml? ( >=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${COMMON_DEPEND}
	aacs? ( >=media-libs/libaacs-0.6.0[${MULTILIB_USEDEP}] )
	bdplus? ( media-libs/libbdplus[${MULTILIB_USEDEP}] )
	java? ( >=virtual/jre-1.6 )
"
DEPEND="
	${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.6 )
"
BDEPEND="
	java? (
		>=virtual/jdk-1.6
		dev-java/ant-core
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-jars.patch
)

DOCS=(
	ChangeLog
	README.txt
)

src_prepare() {
	default

	# bug #714610
	append-cflags -fcommon

	eautoreconf
}

multilib_src_configure() {
	use java || unset JDK_HOME # Bug #621992.

	ECONF_SOURCE="${S}" econf \
		--disable-optimizations \
		$(multilib_native_use_enable utils examples) \
		$(multilib_native_use_enable java bdjava-jar) \
		$(use_with fontconfig) \
		$(use_with truetype freetype) \
		$(use_enable static-libs static) \
		$(use_with xml libxml2)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	multilib_is_native_abi || return

	use utils &&
		find .libs/ -type f -executable ! -name "${PN}.*" \
			 $(use java || echo '! -name bdj_test') -exec dobin {} +

	use java &&
		java-pkg_regjar "${ED}"/usr/share/${PN}/lib/*.jar
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
