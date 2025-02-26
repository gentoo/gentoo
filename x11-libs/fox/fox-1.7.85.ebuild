# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="C++ Toolkit for developing Graphical User Interfaces easily and effectively"
HOMEPAGE="http://www.fox-toolkit.org/"
SRC_URI="ftp://www.fox-toolkit.org/pub/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1.7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="+bzip2 +jpeg +opengl tiff +truetype +zlib debug doc profile tools"

COMMON_DEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	bzip2? ( app-arch/bzip2 )
	jpeg? ( media-libs/libjpeg-turbo:= )
	opengl? ( virtual/glu virtual/opengl )
	tiff? ( media-libs/tiff:= )
	truetype? (
		media-libs/fontconfig
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
	"${FILESDIR}"/${PN}-1.7.85-sanitize.patch
	"${FILESDIR}"/${PN}-1.7.85-tools.patch
	# fix from snapshot-1.7.86. to remove in the next release.
	"${FILESDIR}"/${PN}-1.7.85-fix-metaclass-header.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=strict-aliasing (bug #864412, bug #940648)
	# Do not trust it for LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	use debug || append-cppflags -DNDEBUG

	# Not using --enable-release because of the options it sets like no SSP
	econf \
		$(use_enable debug) \
		$(use_enable bzip2 bz2lib) \
		$(use_enable jpeg) \
		$(use_with opengl) \
		$(use_enable tiff) \
		$(use_with truetype xft) \
		$(use_enable zlib) \
		$(use_with profile profiling) \
		$(use_with tools)
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
