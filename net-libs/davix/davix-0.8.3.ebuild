# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-any-r1

DESCRIPTION="High-performance file management over WebDAV/HTTP"
HOMEPAGE="https://github.com/cern-fts/davix"
SRC_URI="https://github.com/cern-fts/${PN}/releases/download/R_${PV//./_}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6 test tools"
RESTRICT="!test? ( test )"

CDEPEND="
		dev-libs/libxml2:2=
		dev-libs/openssl:0=
		net-libs/gsoap[ssl,-gnutls]
		net-misc/curl:0=
		kernel_linux? ( sys-apps/util-linux )
"

DEPEND="${CDEPEND}"
BDEPEND="
		doc? (
			app-doc/doxygen[dot]
			dev-python/sphinx
		)
		virtual/pkgconfig
		${PYTHON_DEPS}
"

RDEPEND="${CDEPEND}"

REQUIRED_USE="test? ( tools )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.3-enable-ctest.patch
)

src_prepare() {
	cmake_src_prepare

	for x in doc test; do
		if ! use $x; then
			sed -i -e "/add_subdirectory ($x)/d" CMakeLists.txt
		fi
	done
}

src_configure() {
	local mycmakeargs=(
		-DPython_EXECUTABLE="${PYTHON}"
		-DDOC_INSTALL_DIR="${EPREFIX}/usr/share/doc/${P}"
		-DEMBEDDED_LIBCURL=OFF
		-DLIBCURL_BACKEND_BY_DEFAULT=OFF
		-DENABLE_HTML_DOCS=$(usex doc)
		-DENABLE_IPV6=$(usex ipv6)
		-DENABLE_TCP_NODELAY=TRUE
		-DENABLE_THIRD_PARTY_COPY=TRUE
		-DENABLE_TOOLS=$(usex tools)
		-DHTML_INSTALL_DIR="${EPREFIX}/usr/share/doc/${P}/html"
		-DSOUND_INSTALL_DIR="${EPREFIX}/usr/share/${PN}/sounds"
		-DSTATIC_LIBRARY=OFF
		-DSYSCONF_INSTALL_DIR="${EPREFIX}/etc"
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_src_compile doc
	fi
}

src_install() {
	cmake_src_install
	if use test; then
		rm "${ED}/usr/bin/davix-unit-tests" || die
	fi
}
