# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
PYTHON_DEPEND="python? 2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="pyportmidi"

inherit cmake-utils distutils eutils multilib java-pkg-opt-2

DESCRIPTION="A library for real time MIDI input and output"
HOMEPAGE="http://portmedia.sourceforge.net/"
SRC_URI="mirror://sourceforge/portmedia/${PN}-src-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc java python static-libs test-programs"

CDEPEND="media-libs/alsa-lib"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.6 )"
DEPEND="${CDEPEND}
	app-arch/unzip
	java? ( >=virtual/jdk-1.6 )
	python? ( >=dev-python/cython-0.12.1 )
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-tex/xcolor
		virtual/latex-base
	)"

S=${WORKDIR}/${PN}

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use python && python_pkg_setup
}

src_prepare() {
	# fix parallel make failures, fix java support, and allow optional
	# components like test programs and static libs to be skipped
	epatch "${FILESDIR}"/${P}-cmake.patch

	# add include directories and remove references to missing files
	epatch "${FILESDIR}"/${P}-python.patch

	# install wrapper for pmdefaults
	if use java ; then
		cat > pm_java/pmdefaults/pmdefaults <<-EOF
			#!/bin/sh
			java -Djava.library.path="${EPREFIX}/usr/$(get_libdir)/" \\
				-jar "${EPREFIX}/usr/share/${PN}/lib/pmdefaults.jar"
		EOF
		[[ $? -ne 0 ]] && die "cat pmdefaults failed"
	fi

	use python && python_copy_sources
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	local mycmakeargs=(
		$(cmake-utils_use java PORTMIDI_ENABLE_JAVA)
		$(cmake-utils_use static-libs PORTMIDI_ENABLE_STATIC)
		$(cmake-utils_use test-programs PORTMIDI_ENABLE_TEST)
	)

	if use java ; then
		mycmakeargs+=(-DJAR_INSTALL_DIR="${EPREFIX}/usr/share/${PN}/lib")
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use python ; then
		sed -i -e "/library_dirs=.*linux/s#./linux#${CMAKE_BUILD_DIR}#" pm_python/setup.py || die
		pushd pm_python > /dev/null
		distutils_src_compile
		popd > /dev/null
	fi

	if use doc ; then
		doxygen || die "doxygen failed"
		pushd latex > /dev/null
		VARTEXFONTS="${T}"/fonts emake
		popd > /dev/null
	fi
}

src_install() {
	cmake-utils_src_install

	dodoc CHANGELOG.txt README.txt pm_linux/README_LINUX.txt

	use doc && dodoc latex/refman.pdf

	if use python ; then
		pushd pm_python > /dev/null
		distutils_src_install
		popd > /dev/null
	fi

	if use java ; then
		newdoc pm_java/README.txt README_JAVA.txt
		newicon pm_java/pmdefaults/pmdefaults-icon.png pmdefaults.png
		make_desktop_entry pmdefaults Pmdefaults pmdefaults "AudioVideo;Audio;Midi;"
	fi

	if use test-programs ; then
		exeinto /usr/$(get_libdir)/${PN}
		local app
		for app in latency midiclock midithread midithru mm qtest sysex test ; do
			doexe "${CMAKE_BUILD_DIR}"/${app}
		done
	fi
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
