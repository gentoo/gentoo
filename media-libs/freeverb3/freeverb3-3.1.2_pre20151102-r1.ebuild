# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils multilib versionator

MY_PV=796b552e8a32cc8e63d40dfb94b8a6209731060b
DESCRIPTION="Reverb and Impulse Response Convolution library including Audacious/JACK plugins"
HOMEPAGE="https://savannah.nongnu.org/projects/freeverb3"
SRC_URI="https://www.hartwork.org/public/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
_IUSE_INSTRUCTION_SETS="cpu_flags_x86_3dnow cpu_flags_x86_avx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_sse4_1"
IUSE="${_IUSE_INSTRUCTION_SETS} audacious forcefpu jack openmp plugdouble threads"

_GTK_DEPEND=">=dev-libs/glib-2.4.7:2
	>=x11-libs/gtk+-3.0.0:3
	x11-libs/pango
	x11-libs/cairo"

RDEPEND=">=sci-libs/fftw-3.0.1
	audacious? (
		|| ( >=media-sound/audacious-3.7[gtk3]
			( >=media-sound/audacious-3.6 <media-sound/audacious-3.7 ) )
		${_GTK_DEPEND}
		media-libs/libsndfile )
	jack? ( media-sound/jack-audio-connection-kit
		${_GTK_DEPEND}
		media-libs/libsndfile )"
DEPEND=${RDEPEND}

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
        --disable-profile \
		--enable-release \
		--disable-autocflags \
		--enable-undenormal \
		$(use_enable threads pthread) \
		$(use_enable forcefpu) \
		--disable-force3dnow \
		$(use_enable cpu_flags_x86_3dnow 3dnow) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse4) \
		$(use_enable cpu_flags_x86_avx avx) \
		--disable-fma \
		--disable-fma4 \
		$(use_enable openmp omp) \
		--disable-sample \
		$(use_enable jack) \
		$(use_enable audacious) \
		--disable-srcnewcoeffs \
		$(use_enable plugdouble) \
		--disable-pluginit \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README || die 'dodoc failed'

	if use audacious ; then
		find "${D}/usr/$(get_libdir)/audacious/" -name '*.la' -print -delete || die
	fi

	insinto /usr/share/${PN}/samples/IR
	doins samples/IR/*.wav || die
}
