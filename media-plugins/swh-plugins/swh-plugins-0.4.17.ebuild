# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Large collection of LADSPA audio plugins/effects"
HOMEPAGE="http://plugin.org.uk"
SRC_URI="https://github.com/swh/ladspa/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="nls cpu_flags_x86_3dnow cpu_flags_x86_sse"

RDEPEND="
	>=media-sound/gsm-1.0.13-r1[${MULTILIB_USEDEP}]
	>=sci-libs/fftw-3.3.3-r2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
	sys-devel/gettext
"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README TODO )

S="${WORKDIR}/ladspa-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-system-gsm.patch"
)

src_prepare() {
	default

	append-cflags -fPIC -DPIC

	# Use system libgsm, also patch above, bug #252890
	rm -rf gsm

	NOCONFIGURE=1 ./autogen.sh

	elibtoolize

	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_3dnow 3dnow) \
		$(use_enable nls) \
		--enable-fast-install \
		--disable-dependency-tracking \
		RANLIB="$(tc-getRANLIB)"
}

multilib_src_compile() {
	emake RANLIB="$(tc-getRANLIB)"
}

pkg_postinst() {
	ewarn "WARNING: You have to be careful when using the"
	ewarn "swh plugins. Be sure to lower your sound volume"
	ewarn "and then play around a bit with the plugins so"
	ewarn "you get a feeling for it. Otherwise your speakers"
	ewarn "won't like that."
	einfo "If you use only 64 bit sequencers, you may want to disable 32 bit support via USE flag"
	einfo "example| media-plugins/swh-plugins -abi_x86_32"
}
