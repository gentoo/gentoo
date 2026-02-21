# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="High-performance messaging interface for distributed applications"
HOMEPAGE="https://nanomsg.org/"
SRC_URI="https://github.com/nanomsg/nanomsg/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/6.0.1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~riscv ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( dev-ruby/asciidoctor )"

PATCHES=(
		"${FILESDIR}/nanomsg-1.2.2-cmake4.patch" # 964728
)

src_prepare() {
	# Old CPUs like HPPA fail tests because of timeout
	sed -i \
		-e '/inproc_shutdown/s/10/80/' \
		-e '/ws_async_shutdown/s/10/80/' \
		-e '/ipc_shutdown/s/40/80/' CMakeLists.txt || die

	rm -vr demo || die # unused, causing bug #963845

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DNN_STATIC_LIB=OFF
		-DNN_ENABLE_DOC=$(usex doc)
		-DNN_TESTS=$(usex test)
	)

	cmake_src_configure
}
