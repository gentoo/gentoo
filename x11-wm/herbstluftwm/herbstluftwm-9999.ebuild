# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_OPTIONAL=1

inherit cmake distutils-r1 toolchain-funcs

DESCRIPTION="A manual tiling window manager for X"
HOMEPAGE="https://herbstluftwm.org/"

if [[ "${PV}" == "9999" ]] || [[ -n "${EGIT_COMMIT_ID}" ]]; then
	EGIT_REPO_URI="https://github.com/herbstluftwm/herbstluftwm"
	inherit git-r3
else
	SRC_URI="https://herbstluftwm.org/tarballs/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="+doc python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	media-libs/freetype
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr
"
RDEPEND="
	${DEPEND}
	app-shells/bash
	python? ( ${PYTHON_DEPS} )
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

if [[ -n "${EGIT_REPO_URI}" ]]; then
	# Herbstluftwm tarballs ship with pre-compiled documentation, only
	# if we build from git asciidoc is needed.
	BDEPEND+=" doc? ( app-text/asciidoc )"
fi

src_prepare() {
	# Do not install LICENSE and respect CMAKE_INSTALL_DOCDIR.
	sed -i \
		-e '/^install.*LICENSEDIR/d' \
		-e '/set(DOCDIR / s#.*#set(DOCDIR ${CMAKE_INSTALL_DOCDIR})#' \
		CMakeLists.txt || die
	cmake_src_prepare

	if use python; then
		pushd "${S}"/python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi
}

src_configure() {
	# Ensure that 'python3' is in PATH. #765118
	python_setup

	mycmakeargs=(
		-DWITH_DOCUMENTATION=$(usex doc)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use python; then
		pushd python > /dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_install() {
	cmake_src_install

	if ! use doc; then
		rm -r "${ED}"/usr/share/doc/${PF}/examples || die
	fi

	if use python; then
		pushd python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi

	# The man pages exists in src_install either in non-live ebuilds,
	# since they are then shipped pre-compiled in herbstluftwm's
	# release tarbal. Or they exist in live ebuilds if the 'doc' USE
	# flag is enabled.
	if [[ "${PV}" != 9999 ]] || use doc; then
		local man_pages=(
			herbstluftwm.1
			herbstclient.1
			herbstluftwm-tutorial.7
		)
		for man_page in "${man_pages[@]}"; do
			doman "doc/${man_page}"
		done
	fi
}
