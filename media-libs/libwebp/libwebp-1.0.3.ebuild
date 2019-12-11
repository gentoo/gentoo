# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools libtool multilib-minimal

MY_P="${P/_/-}"

DESCRIPTION="A lossy image compression format"
HOMEPAGE="https://developers.google.com/speed/webp/download"
SRC_URI="http://downloads.webmproject.org/releases/webp/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/7" # subslot = libwebp soname version
[[ "${PV}" = *_rc* ]] || \
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 gif +jpeg opengl +png static-libs swap-16bit-csp tiff"

# TODO: dev-lang/swig bindings in swig/ subdirectory
RDEPEND="gif? ( media-libs/giflib:= )
	jpeg? ( virtual/jpeg:0= )
	opengl? (
		media-libs/freeglut
		virtual/opengl
		)
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Fix libtool relinking, bug 499270.
	#elibtoolize
	eautoreconf
}

multilib_src_configure() {
	local args=(
		--enable-libwebpmux
		--enable-libwebpdemux
		--enable-libwebpdecoder
		$(use_enable static-libs static)
		$(use_enable swap-16bit-csp)
		$(use_enable jpeg)
		$(use_enable png)
		$(use_enable opengl gl)
		$(use_enable tiff)

		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_sse4_1 sse4.1)
		$(use_enable cpu_flags_arm_neon neon)

		# Only used for gif2webp binary wrt #486646
		$(multilib_native_use_enable gif)
	)

	ECONF_SOURCE="${S}" econf "${args[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die
	dodoc AUTHORS ChangeLog doc/*.txt NEWS README{,.mux}
}
