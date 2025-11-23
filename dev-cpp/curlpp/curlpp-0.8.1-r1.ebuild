# Copyright 2018-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ wrapper for libcURL"
HOMEPAGE="https://www.curlpp.org/"
SRC_URI="https://github.com/jpbarrette/curlpp/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc examples"

RDEPEND="
	net-misc/curl
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/curlpp-0.8.1-cmake_minimum.patch"
	"${FILESDIR}/curlpp-0.8.1-fix-curloption.patch"
	"${FILESDIR}/curlpp-0.8.1-fix-pkgconfig.patch"
)

DOCS=( Readme.md doc/AUTHORS doc/TODO )

src_install() {
	use doc && DOCS+=( doc/guide.pdf )

	cmake_src_install

	rm "${ED}"/usr/$(get_libdir)/libcurlpp.a || die

	if use examples ; then
		dodoc -r examples/
	fi
}
