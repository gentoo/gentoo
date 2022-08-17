# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

CommitId=41a11409d6ba04e308adc66f5a33115e2d7c9174
DESCRIPTION="implement a crash-reporting system."
HOMEPAGE="https://chromium.googlesource.com/breakpad/breakpad/"
SRC_URI="https://github.com/google/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD BSD-4"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	net-misc/curl
"
DEPEND="${RDEPEND}
	dev-libs/linux-syscall-support
	dev-embedded/libdisasm
"
BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	sed -i \
		-e 's|"third_party/lss\(.*\)"|<lss\1>|' \
		$(find src -name '*.cc' -o -name '*.h') \
		|| die
	sed -i \
		-e '/includelss/d' \
		-e '/third_party\/curl/d' \
		Makefile.am \
		|| die
	sed -i \
		-e "/AC_INIT/s:0.1:${PVR}:" \
		configure.ac \
		|| die
	eautoreconf
}

src_configure() {
	econf \
		--enable-system-test-libs \
		|| die
}
