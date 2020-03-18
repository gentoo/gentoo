# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic cmake-utils

DESCRIPTION="Library for Bible reading software"
HOMEPAGE="http://www.crosswire.org/sword/"
SRC_URI="http://www.crosswire.org/ftpmirror/pub/${PN}/source/v${PV%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~ppc-macos"
IUSE="clucene curl debug doc icu static-libs"

RDEPEND="sys-libs/zlib
	curl? ( net-misc/curl )
	icu? ( dev-libs/icu:= )
	clucene? ( dev-cpp/clucene )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS="AUTHORS CODINGSTYLE ChangeLog README"

RESTRICT="test"	#Restricting for now, see bug 313207

src_prepare() {
	sed -i -e '/^#inc.*curl.*types/d' src/mgr/curl*.cpp || die #378055
	eapply "${FILESDIR}/${PN}-1.7.4-configure.patch"
	eapply "${FILESDIR}/${PN}-1.8.1-icu61.diff"
	eapply_user

	cmake-utils_src_prepare
}

src_configure() {
	# bug 618776
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}/etc"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DWITH_CLUCENE=$(usex clucene)
		-DWITH_CURL=$(usex curl)
		-DWITH_ICU=$(usex icu)
		-DWITH_ZLIB=1
	)
	use static-libs && mycmakeargs+=( -DLIBSWORD_LIBRARY_TYPE=Static )

	cmake-utils_src_configure
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +

	if use doc; then
		rm -rf examples/.cvsignore
		rm -rf examples/cmdline/.cvsignore
		rm -rf examples/cmdline/.deps
		cp -R samples examples "${ED}"/usr/share/doc/${PF}/
	fi

	insinto /etc
	cmake-utils_src_install
}

pkg_postinst() {
	elog "Check out http://www.crosswire.org/sword/modules/"
	elog "to download modules that you would like to use with SWORD."
	elog "Follow module installation instructions found on"
	elog "the web or in ${EROOT}/usr/share/doc/${PF}/"
}
