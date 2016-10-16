# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools vcs-snapshot multilib-minimal

DESCRIPTION="Implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="http://www.ece.uvic.ca/~mdadams/jasper/"
SRC_URI="https://github.com/mdadams/${PN}/archive/version-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="JasPer2.0"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
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

PATCHES=( "${FILESDIR}/${PN}-1.900.3-remove-stdbool-checks.patch" )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable jpeg libjpeg) \
		$(use_enable opengl) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	dodoc -r doc/.

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
