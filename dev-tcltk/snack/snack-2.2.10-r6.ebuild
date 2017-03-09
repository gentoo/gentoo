# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit autotools autotools-utils distutils-r1 multilib

DESCRIPTION="The Snack Sound Toolkit (Tcl)"
HOMEPAGE="http://www.speech.kth.se/snack/"
SRC_URI="http://www.speech.kth.se/snack/dist/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
SLOT="0"
IUSE="alsa examples python threads vorbis"

RESTRICT="test" # Bug 78354

DEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0=
	alsa? ( media-libs/alsa-lib )
	python? ( ${PYTHON_DEPS} )
	vorbis? ( media-libs/libvorbis )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}/unix"

#PYTHON_MODNAME="tkSnack.py"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/alsa-undef-sym.patch
	"${FILESDIR}"/${P}-CVE-2012-6303-fix.patch
	)

src_prepare() {
	# adds -install_name (soname on Darwin)
	[[ ${CHOST} == *-darwin* ]] && PATCHES+=( "${FILESDIR}"/${P}-darwin.patch )

	sed \
		-e "s:ar cr:$(tc-getAR) cr:g" \
		-e "s:-O:${CFLAGS}:g" \
		-i Makefile.in || die

	cd .. || die

	autotools-utils_src_prepare

	sed \
		-e 's|^\(#define roundf(.*\)|//\1|' \
		-i generic/jkFormatMP3.c || die
}

src_configure() {
	local myeconfargs=(
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--includedir="${EPREFIX}"/usr/include
		)

	use alsa && myconf+=( --enable-alsa )
	use threads && myconf+=( --enable-threads )

	use vorbis && \
		myconf+=( --with-ogg-include="${EPREFIX}"/usr/include ) && \
		myconf+=( --with-ogg-lib="${EPREFIX}"/usr/$(get_libdir) )

	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install

	if use python ; then
		cd "${S}"/../python || die
		distutils-r1_src_install
	fi

	cd "${S}"/.. || die

	dohtml doc/*

	if use examples ; then
		docinto examples
		sed -i -e 's/wish[0-9.]+/wish/g' demos/tcl/* || die
		dodoc -r demos/tcl

		use python && dodoc -r demos/python
	fi
}
