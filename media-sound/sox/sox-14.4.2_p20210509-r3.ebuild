# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

# We take a snapshot because of the huge number of security
# and other fixes since the release of 14.4.2.
# Recommend mirroring the snapshot; unclear if they are stable URIs.
COMMIT="42b3557e13e0fe01a83465b672d89faddbe65f49"
MY_P="sox-code-${COMMIT}"

PATCHSET="${P}-patchset"

DESCRIPTION="The swiss army knife of sound processing programs"
HOMEPAGE="https://sox.sourceforge.net"
# Source: https://sourceforge.net/code-snapshots/git/s/so/sox/code.git/${MY_P}.zip
SRC_URI="https://dev.gentoo.org/~fordfrog/distfiles/${MY_P}.zip -> ${P}.zip
	https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="alsa amr ao encode flac id3tag ladspa mad ogg openmp oss opus png pulseaudio sndfile sndio twolame wavpack"

RDEPEND="
	dev-libs/libltdl:0=
	>=media-sound/gsm-1.0.12-r1
	sys-apps/file
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	ao? ( media-libs/libao:= )
	encode? ( >=media-sound/lame-3.98.4 )
	flac? ( >=media-libs/flac-1.1.3:= )
	id3tag? ( media-libs/libid3tag:= )
	ladspa? ( media-libs/ladspa-sdk )
	mad? ( media-libs/libmad )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	opus? (
		media-libs/opus
		media-libs/opusfile
	)
	png? (
		media-libs/libpng:0=
		virtual/zlib:=
	)
	pulseaudio? ( media-libs/libpulse )
	sndfile? ( >=media-libs/libsndfile-1.0.11 )
	sndio? ( media-sound/sndio:= )
	twolame? ( media-sound/twolame )
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	dev-build/autoconf-archive
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS )

PATCHES=( "${WORKDIR}/${PATCHSET}" ) # bug 838382

src_prepare() {
	default

	# bug #386027
	sed -i -e 's|CFLAGS="-g"|CFLAGS="$CFLAGS -g"|' configure.ac || die

	# bug #712630
	if use elibc_musl ; then
		ewarn "Applying musl workaround for bug #712630."
		ewarn "File-type detection with pipes may be missing."
		sed -i '/error FIX NEEDED HERE/d' src/formats.c || die
	fi

	eautoreconf
}

src_configure() {
	# Workaround for LLD (bug #914867)
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)
	local myeconfargs=(
		$(use_enable alsa)
		$(use_enable amr amrnb)
		$(use_enable amr amrwb)
		$(use_enable ao)
		$(use_with encode lame)
		$(use_enable flac)
		$(use_with id3tag)
		$(use_with ladspa ladspa dyn)
		$(use_with mad)
		--with-magic
		$(use_enable openmp)
		$(use_enable ogg oggvorbis)
		$(use_enable oss)
		$(use_enable opus)
		$(use_with png)
		$(use_enable pulseaudio)
		$(use_enable sndfile)
		$(use_enable sndio)
		$(use_with twolame)
		$(use_enable wavpack)
		--enable-formats=dyn
		--with-distro="Gentoo"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
