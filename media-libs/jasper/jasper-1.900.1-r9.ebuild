# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# outdated './configure': breaks in 'USE=opengl ABI_X86="32 64"' case:
#  uses /usr/lib64 for 32-bit ABI.
AUTOTOOLS_AUTORECONF=yes

inherit autotools-multilib

DESCRIPTION="Implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="http://www.ece.uvic.ca/~mdadams/jasper/"
SRC_URI="
	http://www.ece.uvic.ca/~mdadams/${PN}/software/${P}.zip
	mirror://gentoo/${P}-fixes-20120611.patch.bz2"

LICENSE="JasPer2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="jpeg opengl static-libs"

RDEPEND="
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/opengl-7.0-r1:0[${MULTILIB_USEDEP}]
		>=media-libs/freeglut-2.8.1:0[${MULTILIB_USEDEP}]
		virtual/glu
		)"
DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=(
	"${WORKDIR}"/${P}-fixes-20120611.patch
	"${FILESDIR}"/${PN}-1.701.0-GL-ac.patch
	"${FILESDIR}"/${PN}-1.701.0-GL.patch
	"${FILESDIR}"/${PN}-CVE-2014-9029.patch
	"${FILESDIR}"/${PN}-CVE-2014-8137.patch
	"${FILESDIR}"/${PN}-CVE-2014-8138.patch
	"${FILESDIR}"/${PN}-CVE-2014-8157.patch
	"${FILESDIR}"/${PN}-CVE-2014-8158.patch
	"${FILESDIR}"/${PN}-pkgconfig.patch
	)

DOCS=( NEWS README doc/. )

src_prepare() {
	chmod -R o-w "${S}" || die
	autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable jpeg libjpeg)
		$(use_enable opengl)
		)
	autotools-multilib_src_configure
}
