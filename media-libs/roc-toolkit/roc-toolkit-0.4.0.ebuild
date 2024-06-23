# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="Real-time audio streaming over the network"
HOMEPAGE="https://roc-streaming.org/toolkit/docs/ https://github.com/roc-streaming/roc-toolkit/"
SRC_URI="https://github.com/roc-streaming/roc-toolkit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="alsa llvm-libunwind pulseaudio sox sndfile ssl tools test unwind"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/libuv-1.35.0:=
	>=media-libs/openfec-1.4.2.9
	>=media-libs/speexdsp-1.2.0
	alsa? ( >=media-libs/alsa-lib-1.1.9 )
	pulseaudio? ( >=media-libs/libpulse-12.2 )
	sox? ( >=media-sound/sox-14.4.2 )
	sndfile? ( >=media-libs/libsndfile-1.0.28 )
	ssl? ( >=dev-libs/openssl-3.0.8:= )
	unwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind:= )
		!llvm-libunwind? ( >=sys-libs/libunwind-1.2.1:= )
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/ragel
	virtual/pkgconfig
	test? ( dev-util/cpputest )
	tools? ( dev-util/gengetopt )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.5-dont-force-O3.patch
)

src_prepare() {
	default

	# These tests need network
	rm -r \
		src/tests/roc_netio \
		src/tests/public_api/test_receiver.cpp \
		|| die
}

src_compile() {
	tc-export AR CXX CC LD RANLIB OBJCOPY PKG_CONFIG

	# Can revisit these on request, but:
	#
	# * openfec is unconditionally enabled as upstream docs recommend it,
	# see https://roc-streaming.org/toolkit/docs/building/user_cookbook.html.
	#
	# * speexdsp is unconditionally enabled as it's tiny.
	scons_opts=(
		$(usev !alsa '--disable-alsa')
		$(usev !sox '--disable-sox')
		$(usev !pulseaudio '--disable-pulseaudio')
		$(usev !tools '--disable-tools')
		$(usev test '--enable-tests')
		$(usev !sndfile '--disable-sndfile')
		$(usev !ssl '--disable-openssl')
		$(usev !unwind '--disable-libunwind')
	)

	STRIP=true escons "${scons_opts[@]}"
}

src_test() {
	STRIP=true escons "${scons_opts[@]}" test
}

src_install() {
	STRIP=true escons DESTDIR="${D}" "${scons_opts[@]}" install
}
