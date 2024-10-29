# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib flag-o-matic toolchain-funcs

DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
HOMEPAGE="https://www.breakfastquay.com/rubberband/"
SRC_URI="https://breakfastquay.com/files/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="ladspa lv2 jni static-libs +programs test vamp"
RESTRICT="!test? ( test )"

DEPEND="
	media-libs/libsamplerate[${MULTILIB_USEDEP}]
	sci-libs/fftw:3.0[${MULTILIB_USEDEP}]
	jni? ( >=virtual/jdk-1.8:* )
	ladspa? ( media-libs/ladspa-sdk[${MULTILIB_USEDEP}] )
	lv2? ( media-libs/lv2[${MULTILIB_USEDEP}] )
	programs? ( media-libs/libsndfile[${MULTILIB_USEDEP}] )
	vamp? ( media-libs/vamp-plugin-sdk[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	ppc? ( sys-devel/gcc:* )
"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-libs/boost[${MULTILIB_USEDEP}] )
"

EMESON_BUILDTYPE=release

src_prepare() {
	sed -i \
		-e "s/if have_jni/if get_option('jni')/g" \
		-e "s/if have_ladspa/if get_option('ladspa')/g" \
		-e "s/if have_lv2/if get_option('lv2')/g" \
		-e "s/if have_vamp/if get_option('vamp')/g" \
		-e "s/if have_sndfile/if get_option('cmdline')/g" \
	"meson.build" || die

	sed -i -e "s/type: 'feature', value: 'auto'/type: 'boolean', value: 'false'/g" "meson_options.txt" || die

	default
}

multilib_src_configure() {
	if use ppc ; then
		# bug #827203
		# meson doesn't respect/use LIBS but mangles LDFLAGS with libs
		# correctly. Use this until we get a Meson test for libatomic.
		append-ldflags -latomic
	elif tc-is-clang && [[ $(tc-get-cxx-stdlib) == libstdc++ ]] ; then
		# bug #860078
		# undefined reference to `__atomic_is_lock_free'
		append-ldflags -latomic
	fi

	local emesonargs=(
		-Dfft=fftw
		-Dresampler=libsamplerate
		-Ddefault_library=$(use static-libs && echo "both" || echo "shared")
		$(meson_use ladspa)
		$(meson_use lv2)
		$(meson_use jni)
		$(meson_use programs cmdline)
		$(meson_use vamp)
		$(meson_use test tests)
	)
	use jni && emesonargs+=(
		-Dextra_include_dirs="$(java-config -g JAVA_HOME)/include,$(java-config -g JAVA_HOME)/include/linux"
	)
	meson_src_configure
}

multilib_src_test() {
	meson_src_test --timeout-multiplier=30
}

multilib_src_install_all() {
	! use jni && find "${ED}" -name "*.a" -delete
}
