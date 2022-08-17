# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ninja: error: build.ninja:521: multiple rules generate pm_java/pmdefaults.jar [-w dupbuild=err]
CMAKE_MAKEFILE_GENERATOR="emake"
# Python bindings dropped b/c of bug #855077
inherit cmake desktop xdg java-pkg-opt-2

MY_P="portmedia-code-r${PV}"

DESCRIPTION="Library for real time MIDI input and output"
HOMEPAGE="http://portmedia.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/portmedia/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="debug doc java static-libs test-programs"

BDEPEND="
	app-arch/unzip
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
"
CDEPEND="
	media-libs/alsa-lib
"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.8:* )
"
DEPEND="
	${CDEPEND}
	java? ( >=virtual/jdk-1.8:* )
"

S="${WORKDIR}/${MY_P}/${PN}/trunk"
MAKEOPTS+=" -j1"

PATCHES=(
	# fix parallel make failures, fix java support, and allow optional
	# components like test programs and static libs to be skipped
	"${FILESDIR}"/${P}-cmake.patch
)

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# install wrapper for pmdefaults
	if use java ; then
		cat > pm_java/pmdefaults/pmdefaults <<-EOF
			#!/bin/sh
			java -Djava.library.path="${EPREFIX}/usr/$(get_libdir)/" \\
				-jar "${EPREFIX}/usr/share/${PN}/lib/pmdefaults.jar"
		EOF
		[[ $? -ne 0 ]] && die "cat pmdefaults failed"
	fi
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	local mycmakeargs=(
		-DPORTMIDI_ENABLE_JAVA=$(usex java)
		-DPORTMIDI_ENABLE_STATIC=$(usex static-libs)
		-DPORTMIDI_ENABLE_TEST=$(usex test-programs)
	)

	if use java ; then
		mycmakeargs+=(-DJAR_INSTALL_DIR="${EPREFIX}/usr/share/${PN}/lib")
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		doxygen || die "doxygen failed"
		pushd latex > /dev/null
		VARTEXFONTS="${T}"/fonts emake
		popd > /dev/null
	fi
}

src_install() {
	cmake_src_install

	dodoc CHANGELOG.txt README.txt pm_linux/README_LINUX.txt

	use doc && dodoc latex/refman.pdf

	if use java ; then
		newdoc pm_java/README.txt README_JAVA.txt
		newicon pm_java/pmdefaults/pmdefaults-icon.png pmdefaults.png
		make_desktop_entry pmdefaults Pmdefaults pmdefaults "AudioVideo;Audio;Midi;"
	fi

	if use test-programs ; then
		exeinto /usr/$(get_libdir)/${PN}
		local app
		for app in latency midiclock midithread midithru mm qtest sysex test ; do
			doexe "${BUILD_DIR}"/${app}
		done
	fi
}
