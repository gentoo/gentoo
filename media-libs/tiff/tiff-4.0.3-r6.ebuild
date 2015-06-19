# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-4.0.3-r6.ebuild,v 1.13 2014/06/18 19:58:32 mgorny Exp $

EAPI=5
inherit eutils libtool multilib-minimal

DESCRIPTION="Tag Image File Format (TIFF) library"
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="http://download.osgeo.org/libtiff/${P}.tar.gz
	ftp://ftp.remotesensing.org/pub/libtiff/${P}.tar.gz"

LICENSE="libtiff"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cxx jbig jpeg lzma static-libs test zlib"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}] )
	jbig? ( >=media-libs/jbigkit-2.1:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r9
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}"

REQUIRED_USE="test? ( jpeg )" #483132

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/tiffconf.h
)

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0.3-tiff2pdf-colors.patch #145055
	epatch "${FILESDIR}"/${P}-CVE-2012-{4447,4564}.patch #440944
	epatch "${FILESDIR}"/${P}-CVE-2013-{1960,1961}.patch #468334
	epatch "${FILESDIR}"/${P}-CVE-2013-{4231,4232}.patch #480466
	epatch "${FILESDIR}"/${P}-CVE-2013-4244.patch #486590
	epatch "${FILESDIR}"/${P}-libjpeg-turbo.patch

	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		$(use_enable jbig) \
		$(use_enable lzma) \
		$(use_enable cxx) \
		--without-x \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}

	# remove useless subdirs
	if ! multilib_is_native_abi ; then
		sed -i \
			-e 's/ tools//' \
			-e 's/ contrib//' \
			-e 's/ man//' \
			-e 's/ html//' \
			Makefile || die
	fi
}

multilib_src_test() {
	if ! multilib_is_native_abi ; then
		cd tools
		emake
		cd "${BUILD_DIR}"
	fi
	emake check
}

multilib_src_install_all() {
	prune_libtool_files --all
	rm -f "${ED}"/usr/share/doc/${PF}/{COPYRIGHT,README*,RELEASE-DATE,TODO,VERSION}
}
