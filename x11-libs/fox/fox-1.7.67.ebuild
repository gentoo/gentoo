# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

LICENSE="LGPL-2.1"
SLOT="1.7"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="+bzip2 +jpeg +opengl +png tiff +truetype +zlib debug doc profile"

RDEPEND="x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/fox-wrapper
	bzip2? ( app-arch/bzip2 )
	jpeg? ( virtual/jpeg:= )
	opengl? ( virtual/glu virtual/opengl )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )
	truetype? ( media-libs/freetype:2
		x11-libs/libXft )
	zlib? ( sys-libs/zlib )
	doc? ( app-doc/doxygen )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXt"

DESCRIPTION="C++ Toolkit for developing Graphical User Interfaces easily and effectively"
HOMEPAGE="http://www.fox-toolkit.org/"
SRC_URI="ftp://ftp.fox-toolkit.org/pub/${P}.tar.gz"

PATCHES=( "${FILESDIR}"/"${PN}"-1.7.67-no-truetype.patch )

src_prepare() {
	default

	sed -i '/#define REXDEBUG 1/d' lib/FXRex.cpp || die "Unable to remove spurious debug line."
	local d
	for d in windows adie calculator pathfinder shutterbug; do
		sed -i -e "s:${d}::" Makefile.am || die "Unable to remove $d."
	done

	# Respect system CXXFLAGS
	sed -i -e 's:CXXFLAGS=""::' configure.ac || die "Unable to force cxxflags."

	# don't strip binaries
	sed -i -e '/LDFLAGS="-s ${LDFLAGS}"/d' configure.ac || die "Unable to prevent stripping."

	eautoreconf
}

src_configure() {
	econf \
		$(use debug && echo --enable-debug || echo --enable-release) \
		$(use_enable bzip2 bz2lib) \
		$(use_enable jpeg) \
		$(use_with opengl) \
		$(use_enable png) \
		$(use_enable tiff) \
		$(use_with truetype xft) \
		$(use_enable zlib) \
		$(use_with profile profiling)
}

src_compile() {
	emake || die "compile error"
	use doc && emake -C "${S}"/doc docs
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		htmldir=/usr/share/doc/${PF}/html \
		artdir=/usr/share/doc/${PF}/html/art \
		screenshotsdir=/usr/share/doc/${PF}/html/screenshots

	CP="${ED}/usr/bin/ControlPanel"
	if [[ -f ${CP} ]] ; then
		mv "${CP}" "${ED}/usr/bin/fox-ControlPanel-${SLOT}" || \
			die "Failed to install ControlPanel"
	fi

	for doc in ADDITIONS AUTHORS LICENSE_ADDENDUM README TRACING ; do
		[ -f $doc ] && dodoc $doc
	done

	# remove documentation if USE=-doc
	use doc || rm -fr "${D}/usr/share/doc/${PF}/html"

	# install class reference docs if USE=doc
	if use doc && [[ -z ${FOX_COMPONENT} ]] ; then
		dohtml -r "${S}/doc/ref"
	fi

	# slot fox-config
	if [[ -f ${D}/usr/bin/fox-config ]] ; then
		mv "${D}/usr/bin/fox-config" "${D}/usr/bin/fox-${SLOT}-config" \
		|| die "failed to install fox-config"
	fi
}
