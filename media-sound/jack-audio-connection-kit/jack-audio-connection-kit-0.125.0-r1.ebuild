# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic eutils multilib-minimal

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="https://github.com/jackaudio/jack1/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~s390 ~sparc"
IUSE="cpu_flags_x86_3dnow altivec alsa coreaudio doc debug examples oss cpu_flags_x86_sse pam"

# readline: only used for jack_transport -> useless for non native ABIs
# libsndfile: ditto for jackrec
# zita: ditto for jackd
RDEPEND="
	sys-libs/db:=[${MULTILIB_USEDEP}]
	sys-libs/readline:0=
	>=media-libs/libsndfile-1.0.0
	alsa? (
		>=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}]
		media-libs/zita-resampler
		media-libs/zita-alsa-pcmi
	)
	>=media-libs/libsamplerate-0.1.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}
	alsa? ( sys-process/lsof )
	pam? ( sys-auth/realtime-base )"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS TODO README )

PATCHES=(
	"${FILESDIR}/${PN}-0.125.0-freebsd.patch"
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=""

	# Disabling CPU Detection (dynsimd) disables optimized asm routines (3dnow
	# or sse)
	if use cpu_flags_x86_3dnow || use cpu_flags_x86_sse ; then
		myconf="${myconf} --enable-dynsimd"
	fi

	if multilib_is_native_abi ; then
		myconf="${myconf} $(use_enable alsa zalsa)"
	else
		myconf="${myconf} --disable-zalsa"
	fi

	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	econf \
		$(use_enable altivec) \
		$(use_enable alsa) \
		$(use_enable coreaudio) \
		$(use_enable debug) \
		$(use_enable oss) \
		--disable-portaudio \
		--disable-firewire \
		$(use_enable cpu_flags_x86_sse sse) \
		--with-html-dir=/usr/share/doc/${PF} \
		${myconf}

	if ! multilib_is_native_abi ; then
		for i in tools man ; do
			sed -i -e "s/ ${i}//" Makefile || die
		done
	fi
}

multilib_src_install_all() {
	einstalldocs
	if use examples; then
		dodoc -r "${S}/example-clients"
		docompress -x /usr/share/doc/${PF}/example-clients
	fi
}
