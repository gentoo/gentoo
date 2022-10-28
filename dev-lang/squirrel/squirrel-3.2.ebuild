# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A interpreted language mainly used for games"
HOMEPAGE="http://squirrel-lang.org/"
# Missing file in the tarball, do the same as Mageia
SRC_URI="https://download.sourceforge.net/squirrel/${PN}_${PV/./_}_stable.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/albertodemichelis/squirrel/v${PV}/squirrel-config.cmake.in -> squirrel-config.cmake.in_${PV}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}3"

PATCHES=(
	# Fixed in master
	"${FILESDIR}/${P}-CVE-2022-30292.patch"
)

src_prepare() {
	cp "${DISTDIR}/squirrel-config.cmake.in_${PV}" "${S}/squirrel-config.cmake.in" || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(usex static-libs '' -DDISABLE_STATIC=YES)
		# /usr/bin/sq is used by app-text/ispell
		# /usr/lib/libsquirrel.so is used by app-shells/squirrelsh
		-DLONG_OUTPUT_NAMES=YES
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc HISTORY

	if use examples; then
		docompress -x /usr/share/doc/${PF}/samples
		dodoc -r samples
	fi

	# Add pkgconfig file, needed for some reverse deps (follows Mageia
	# one)
	# https://github.com/albertodemichelis/squirrel/issues/259
	dodir /usr/$(get_libdir)/pkgconfig
	sed \
		-e "s/@libdir@/$(get_libdir)/" \
		-e "s/@version@/${PV}/" \
		"${FILESDIR}/${PN}.pc.in" > "${ED}/usr/$(get_libdir)/pkgconfig/${PN}.pc" || die
}
