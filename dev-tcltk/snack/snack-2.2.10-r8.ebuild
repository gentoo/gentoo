# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools distutils-r1 multilib virtualx

DESCRIPTION="The Snack Sound Toolkit (Tcl)"
HOMEPAGE="http://www.speech.kth.se/snack/"
SRC_URI="http://www.speech.kth.se/snack/dist/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
SLOT="0"
IUSE="alsa examples python vorbis"
RESTRICT="!test? ( test )"

DEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0=
	alsa? ( media-libs/alsa-lib )
	python? ( ${PYTHON_DEPS} )
	vorbis? ( media-libs/libvorbis )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}/unix"

PATCHES=(
	"${FILESDIR}"/alsa-undef-sym.patch
	"${FILESDIR}"/${P}-CVE-2012-6303-fix.patch
	"${FILESDIR}"/${P}-debian-args.patch
	"${FILESDIR}"/${P}-test.patch
)

HTML_DOCS="${WORKDIR}/${PN}${PV}/doc/*"

src_prepare() {
	# adds -install_name (soname on Darwin)
	[[ ${CHOST} == *-darwin* ]] && PATCHES+=( "${FILESDIR}"/${P}-darwin.patch )

	sed \
		-e "s:ar cr:$(tc-getAR) cr:g" \
		-e "s:-O:${CFLAGS}:g" \
		-i Makefile.in || die

	cd ..

	default

	sed \
		-e 's|^\(#define roundf(.*\)|//\1|' \
		-i generic/jkFormatMP3.c || die
	rm tests/{play,record}.test || die
}

src_configure() {
	local myconf=""

	use alsa && myconf+=" --enable-alsa"

	if use vorbis; then
		myconf+=" --with-ogg-include="${EPREFIX}"/usr/include"
		myconf+=" --with-ogg-lib="${EPREFIX}"/usr/$(get_libdir)"
	fi

	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--includedir="${EPREFIX}"/usr/include \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir) \
		$myconf
}

src_compile() {
	default
}

src_test() {
	TCLLIBPATH=${S} virtx default | tee snack.testResult
	grep -q FAILED snack.testResult && die
}

src_install() {
	default

	if use python ; then
		cd "${S}"/../python || die
		distutils-r1_src_install
	fi

	cd "${S}"/.. || die

	if use examples ; then
		docinto examples
		sed -i -e 's/wish[0-9.]+/wish/g' demos/tcl/* || die
		dodoc -r demos/tcl

		use python && dodoc -r demos/python
	fi
}
