# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="Real-time audio streaming over the network"
HOMEPAGE="https://roc-streaming.org/toolkit/docs/ https://github.com/roc-streaming/roc-toolkit/"
SRC_URI="https://github.com/roc-streaming/roc-toolkit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/3"
KEYWORDS="~amd64"
IUSE="alsa llvm-libunwind pulseaudio sox ssl tools test unwind"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libuv:=
	media-libs/openfec
	media-libs/speexdsp
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )
	sox? ( media-sound/sox )
	ssl? ( dev-libs/openssl:= )
	unwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind:= )
		!llvm-libunwind? ( sys-libs/libunwind:= )
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
