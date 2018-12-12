# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Reverb and Impulse Response Convolution plug-ins (Audacious/JACK)"
HOMEPAGE="https://savannah.nongnu.org/projects/freeverb3"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
_IUSE_INSTRUCTION_SETS="cpu_flags_x86_3dnow cpu_flags_x86_avx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_sse4_1"
IUSE="${_IUSE_INSTRUCTION_SETS} audacious forcefpu jack openmp plugdouble threads"

REQUIRED_USE="jack? ( audacious )"

_GTK_DEPEND="
	>=dev-libs/glib-2.4.7:2
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango
"
RDEPEND="
	sci-libs/fftw:3.0=
	audacious? ( ${_GTK_DEPEND}
		=media-sound/audacious-3.9*[gtk3(+)]
		media-libs/libsndfile
	)
	jack? ( ${_GTK_DEPEND}
		virtual/jack
		media-libs/libsndfile
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		--enable-release
		--enable-undenormal
		--disable-autocflags
		--disable-fma
		--disable-fma4
		--disable-force3dnow
		--disable-pluginit
		--disable-profile
		--disable-sample
		--disable-srcnewcoeffs
		$(use_enable audacious)
		$(use_enable cpu_flags_x86_3dnow 3dnow)
		$(use_enable cpu_flags_x86_avx avx)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_sse3 sse3)
		$(use_enable cpu_flags_x86_sse4_1 sse4)
		$(use_enable forcefpu)
		$(use_enable jack)
		$(use_enable openmp omp)
		$(use_enable plugdouble)
		$(use_enable threads pthread)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs

	if use audacious ; then
		find "${D}/usr/$(get_libdir)/audacious/" -name '*.la' -print -delete || die
	fi

	insinto /usr/share/${PN}/samples/IR
	doins samples/IR/*.wav
}
