# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"
inherit eutils multilib-minimal

DESCRIPTION="A lightweight, speed optimized color management engine"
HOMEPAGE="http://www.littlecms.com/"
SRC_URI="mirror://sourceforge/${PN}/lcms2-${PV}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc jpeg static-libs +threads test tiff zlib"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.3-r6:0=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r10
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/lcms2-${PV}

multilib_src_configure() {
	local myeconfargs=(
		$(use_with jpeg)
		$(use_with tiff)
		$(use_with zlib)
		$(use_with threads)
	)
	ECONF_SOURCE="${S}" \
	econf ${myeconfargs[@]}
}

multilib_src_install_all() {
	find "${ED}" \( -name "*.la" -o -name "*.a" \) -delete || die

	if use doc; then
		docinto pdf
		dodoc doc/*.pdf
	fi
}
