# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/cpl/cpl-6.3.1.ebuild,v 1.1 2013/06/07 23:32:10 bicatali Exp $

EAPI=5

JAVA_PKG_OPT_USE=gasgano
AUTOTOOLS_AUTORECONF=1

inherit eutils java-pkg-opt-2 autotools-utils

DESCRIPTION="ESO common pipeline library for astronomical data reduction"
HOMEPAGE="http://www.eso.org/sci/software/cpl/"
SRC_URI="ftp://ftp.eso.org/pub/dfs/pipelines/libraries/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc gasgano static-libs threads"

RDEPEND="
	>=sci-astronomy/wcslib-4.8.4
	>=sci-libs/cfitsio-3.310
	>=sci-libs/fftw-3.1.2
	gasgano? ( sci-astronomy/gasgano )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.1-check-shared-libs.patch
	"${FILESDIR}"/${PN}-6.1.1-use-system-ltdl.patch
)

src_prepare() {
	# bug 422455 and remove cpu chcking
	sed -i \
		-e '/AM_C_PROTOTYPES/d' \
		-e '/CPL_CHECK_CPU/d' \
		configure.ac libcext/configure.ac || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		--disable-ltdl-install
		--without-included-ltdl
		--with-cfitsio="${EPREFIX}/usr"
		--with-wcs="${EPREFIX}/usr"
		--with-fftw="${EPREFIX}/usr"
		$(use_enable doc maintainer-mode)
		$(use_enable threads)
	)
	if use gasgano; then
		myeconfargs+=(
			--enable-gasgano
			--with-gasgano="${EPREFIX}/usr"
			--with-gasgano-classpath="${EPREFIX}/usr/share/gasgano/lib"
			--with-java="$(java-config -O)"
		)
	else
		myeconfargs+=( --disable-gasgano )
	fi
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(use doc && echo html)
}

src_install() {
	autotools-utils_src_install all $(use doc && echo install-html)
}
