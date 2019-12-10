# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="High-performance file management over WebDAV/HTTP"
HOMEPAGE="https://dmc.web.cern.ch/projects/davix"
SRC_URI="http://grid-deployment.web.cern.ch/grid-deployment/dms/lcgutil/tar/${PN}/${PV}/${P}.tar.gz -> ${P}.tar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6 kernel_linux test tools"
RESTRICT="!test? ( test )"

CDEPEND="
		dev-libs/libxml2:2=
		dev-libs/openssl:0=
		kernel_linux? ( sys-apps/util-linux )
"

DEPEND="${CDEPEND}
		doc? (
			app-doc/doxygen[dot]
			dev-python/sphinx
		)
		virtual/pkgconfig
"

RDEPEND="${CDEPEND}"

REQUIRED_USE="test? ( tools )"

src_prepare() {
	cmake-utils_src_prepare

	for x in doc test; do
		if ! use $x; then
			sed -i -e "/add_subdirectory ($x)/d" CMakeLists.txt
		fi
	done
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DDOC_INSTALL_DIR="${EPREFIX}/usr/share/doc/${P}"
		-DENABLE_HTML_DOCS=$(usex doc)
		-DENABLE_IPV6=$(usex ipv6)
		-DENABLE_TOOLS=$(usex tools)
		-DHTML_INSTALL_DIR="${EPREFIX}/usr/share/doc/${P}/html"
		-DSOUND_INSTALL_DIR="${EPREFIX}/usr/share/${PN}/sounds"
		-DSTATIC_LIBRARY=OFF
		-DSYSCONF_INSTALL_DIR="${EPREFIX}/etc"
		-DBUILD_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		cmake-utils_src_compile doc
	fi
}

src_install() {
	cmake-utils_src_install

	if ! use tools; then
		rm -rf "${ED}/usr/share/man/man1"
	fi

	if use test; then
		rm -rf "${ED}/usr/bin/davix-unit-tests"
	fi
}
