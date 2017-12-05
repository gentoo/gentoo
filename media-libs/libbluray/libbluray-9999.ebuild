# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ "${PV#9999}" != "${PV}" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.videolan.org/git/libbluray.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
	SRC_URI="https://ftp.videolan.org/pub/videolan/libbluray/${PV}/${P}.tar.bz2"
fi

inherit autotools java-pkg-opt-2 flag-o-matic eutils multilib-minimal

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="https://www.videolan.org/developers/libbluray.html"

LICENSE="LGPL-2.1"
SLOT="0/2"
IUSE="aacs bdplus +fontconfig java static-libs +truetype udf utils +xml"

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
	java? (
		>=virtual/jdk-1.6
		dev-java/ant-core
	)
	virtual/pkgconfig
"

DOCS=( ChangeLog README.txt )

src_prepare() {
	default

	if use java ; then
		export JDK_HOME="$(java-config -g JAVA_HOME)"

		# don't install a duplicate jar file
		sed -i '/^jar_DATA/d' Makefile.am || die

		java-pkg-opt-2_src_prepare
	fi

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-optimizations \
		$(multilib_native_use_enable utils examples) \
		$(multilib_native_use_enable java bdjava) \
		$(use_with fontconfig) \
		$(use_with truetype freetype) \
		$(use_enable static-libs static) \
		$(use_enable udf) \
		$(use_with xml libxml2)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use utils; then
		cd .libs/
		dobin index_dump mobj_dump mpls_dump bd_info bdsplice clpi_dump hdmv_test libbluray_test list_titles sound_dump
		if use java; then
			dobin bdj_test
		fi
	fi

	if multilib_is_native_abi && use java; then
		java-pkg_dojar "${BUILD_DIR}"/.libs/${PN}-j2se-*.jar
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
