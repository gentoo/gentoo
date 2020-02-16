# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic eutils multilib multilib-minimal

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="http://www.jackaudio.org/downloads/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 ~sh sparc x86"
IUSE="cpu_flags_x86_3dnow altivec alsa coreaudio doc debug examples oss cpu_flags_x86_sse pam"

# readline: only used for jack_transport -> useless for non native ABIs
# libsndfile: ditto for jackrec
RDEPEND="
	sys-libs/db:=[${MULTILIB_USEDEP}]
	sys-libs/readline:0=
	>=media-libs/libsndfile-1.0.0
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	>=media-libs/libsamplerate-0.1.8-r1[${MULTILIB_USEDEP}]
	!media-sound/jack-cvs"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	alsa? ( sys-process/lsof )
	pam? ( sys-auth/realtime-base )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.125.0-freebsd.patch"
}

DOCS=( AUTHORS TODO README )

multilib_src_configure() {
	local myconf=""

	# Disabling CPU Detection (dynsimd) disables optimized asm routines (3dnow
	# or sse)
	if use cpu_flags_x86_3dnow || use cpu_flags_x86_sse ; then
		myconf="${myconf} --enable-dynsimd"
	fi

	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	ECONF_SOURCE="${S}" econf \
		$(use_enable altivec) \
		$(use_enable alsa) \
		$(use_enable coreaudio) \
		$(use_enable debug) \
		$(use_enable oss) \
		--disable-portaudio \
		--disable-firewire \
		$(use_enable cpu_flags_x86_sse sse) \
		--with-html-dir=/usr/share/doc/${PF} \
		--disable-dependency-tracking \
		--libdir=/usr/$(get_libdir) \
		${myconf}

	if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
		for i in tools man ; do
			sed -i -e "s/ ${i}//" Makefile || die
		done
	fi
}

multilib_src_install_all() {
	einstalldocs
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
		docompress -x /usr/share/doc/${PF}/example-clients
	fi
}
