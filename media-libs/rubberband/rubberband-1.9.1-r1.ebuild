# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal

DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
HOMEPAGE="https://www.breakfastquay.com/rubberband/"
SRC_URI="https://breakfastquay.com/files/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ladspa jni static-libs +programs vamp"

BDEPEND="
	virtual/pkgconfig
"
CDEPEND="
	media-libs/libsamplerate[${MULTILIB_USEDEP}]
	sci-libs/fftw:3.0[${MULTILIB_USEDEP}]
	jni? ( virtual/jdk:* )
	ladspa? ( media-libs/ladspa-sdk )
	programs? ( media-libs/libsndfile )
	vamp? ( media-libs/vamp-plugin-sdk[${MULTILIB_USEDEP}] )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

multilib_src_configure() {
	local emesonargs=(
		--buildtype=release
		-Dfft=fftw
		-Dresampler=libsamplerate
		-Dstatic=$(usex static-libs true false)
		$(meson_use ladspa)
		$(meson_use jni)
		$(meson_use programs)
		$(meson_use vamp)
	)
	use jni && emesonargs+=(
		-Dextra_include_dirs="$(java-config -g JAVA_HOME)/include,$(java-config -g JAVA_HOME)/include/linux"
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	! use jni && find ${ED} -name "*.a" -delete
	einstalldocs
}
