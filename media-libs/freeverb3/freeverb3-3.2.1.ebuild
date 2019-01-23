# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib

DESCRIPTION="Reverb and Impulse Response Convolution plug-ins (Audacious/JACK)"
HOMEPAGE="https://savannah.nongnu.org/projects/freeverb3"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audacious jack openmp plugdouble threads"

_GTK_DEPEND=">=dev-libs/glib-2.4.7:2
	>=x11-libs/gtk+-3.0.0:3
	x11-libs/pango
	x11-libs/cairo"

RDEPEND=">=sci-libs/fftw-3.0.1
	audacious? ( >=media-sound/audacious-3.9[gtk3]
		${_GTK_DEPEND}
		media-libs/libsndfile )
	jack? ( media-sound/jack-audio-connection-kit
		${_GTK_DEPEND}
		media-libs/libsndfile )"
DEPEND=${RDEPEND}

REQUIRED_USE="jack? ( audacious )"

src_configure() {
	econf \
		--disable-profile \
		--enable-release \
		--disable-autocflags \
		--enable-undenormal \
		$(use_enable threads pthread) \
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
