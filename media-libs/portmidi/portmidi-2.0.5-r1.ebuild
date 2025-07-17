# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Library for real time MIDI input and output"
HOMEPAGE="https://github.com/PortMidi/portmidi"
SRC_URI="https://github.com/PortMidi/portmidi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug test-programs"
# Per pm-test/README:
# "Because device numbers depend on the system, there is no automated
# script to run all tests on PortMidi."
RESTRICT="test"

RDEPEND="
	media-libs/alsa-lib
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.4-cmake.patch
)

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	# Python bindings dropped b/c of bug #855077
	local mycmakeargs=(
		-DBUILD_PORTMIDI_TESTS=$(usex test-programs)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc CHANGELOG.txt README.txt pm_linux/README_LINUX.txt

	if use test-programs ; then
		exeinto /usr/$(get_libdir)/${PN}
		local app
		for app in latency midiclock midithread midithru mm qtest sysex ; do
			doexe "${BUILD_DIR}"/pm_test/${app}
		done
	fi
}
