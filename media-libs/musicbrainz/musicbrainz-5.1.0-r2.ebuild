# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Client Library for accessing the latest XML based MusicBrainz web service"
HOMEPAGE="https://musicbrainz.org/doc/libmusicbrainz"
SRC_URI="https://github.com/metabrainz/lib${PN}/releases/download/release-${PV}/lib${P}.tar.gz"
S="${WORKDIR}/lib${P}"

LICENSE="LGPL-2.1"
SLOT="5/1" # soname of libmusicbrainz5.so
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="examples test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2:=
	net-libs/neon
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cppunit )
"

PATCHES=(
	"${FILESDIR}/${P}-no-wildcards.patch"
	"${FILESDIR}/${P}-libxml2-2.12.patch"
	"${FILESDIR}/${P}-libxml2-2.12-compat.patch"
)

src_prepare() {
	use test || cmake_comment_add_subdirectory tests
	cmake_src_prepare
}

src_install() {
	cmake_src_install

	if use examples; then
		docinto examples
		dodoc examples/*.{c,cc,txt}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
