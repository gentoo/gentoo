# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="C++ Toolkit for developing Graphical User Interfaces easily and effectively"
HOMEPAGE="http://www.fox-toolkit.org/"
SRC_URI="ftp://www.fox-toolkit.org/pub/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1.7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="+bzip2 +jpeg +opengl +png tiff +truetype +zlib debug doc profile tools"

COMMON_DEPEND="
	x11-libs/libXcursor
	x11-libs/libXrandr
	bzip2? ( app-arch/bzip2 )
	jpeg? ( media-libs/libjpeg-turbo:= )
	opengl? ( virtual/glu virtual/opengl )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
	truetype? (
		media-libs/freetype:2
		x11-libs/libXft
	)
	zlib? ( sys-libs/zlib )
"
RDEPEND="
	${COMMON_DEPEND}
	x11-libs/fox-wrapper
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
	x11-libs/libXt
"
BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.84-pthread_rwlock_prefer_writer_np-musl.patch
)

src_prepare() {
	default

	sed -i -e "s:windows::" Makefile.am || die

	if ! use tools; then
		local d
		for d in adie calculator pathfinder shutterbug; do
			sed -i -e "s:${d}::" Makefile.am || die
		done
	fi

	# Respect system CXXFLAGS
	sed -i -e 's:CXXFLAGS=""::' configure.ac || die "Unable to force cxxflags."

	# don't strip binaries
	sed -i -e '/LDFLAGS="-s ${LDFLAGS}"/d' configure.ac || die "Unable to prevent stripping."

	eautoreconf
}

src_configure() {
	use debug || append-cppflags -DNDEBUG

	# Not using --enable-release because of the options it sets like no SSP
	econf \
		$(use_enable debug) \
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
	emake
	use doc && emake -C doc docs
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		artdir="${EPREFIX}"/usr/share/doc/${PF}/html/art \
		screenshotsdir="${EPREFIX}"/usr/share/doc/${PF}/html/screenshots

	local CP="${ED}"/usr/bin/ControlPanel
	if [[ -f ${CP} ]]; then
		mv "${CP}" "${ED}"/usr/bin/fox-ControlPanel-${SLOT} || \
			die "Failed to install ControlPanel"
	fi

	dodoc ADDITIONS AUTHORS LICENSE_ADDENDUM README TRACING

	if use doc; then
		# install class reference docs if USE=doc
		docinto html
		dodoc -r doc/ref
	else
		# remove documentation if USE=-doc
		rm -rf "${ED}"/usr/share/doc/${PF}/html || die
	fi

	# slot fox-config
	if [[ -f ${ED}/usr/bin/fox-config ]] ; then
		mv "${ED}"/usr/bin/fox-config "${ED}"/usr/bin/fox-${SLOT}-config \
		|| die "failed to install fox-config"
	fi

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
