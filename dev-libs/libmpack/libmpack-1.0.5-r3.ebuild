# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Simple implementation of msgpack in C"
HOMEPAGE="https://github.com/libmpack/libmpack"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${P}-libtool.patch # 778899
)

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-ggdb//g' -i Makefile.in || die
	sed -e 's/-O3//g' -i .config/release.mk || die

	eautoreconf
}

src_compile() {
	local myemakeargs=(
		"VERBOSE=1"
		"PREFIX=${EPREFIX}/usr"
		"CC=$(tc-getCC)"
		"config=release"
		"LIBDIR=${EPREFIX}/usr/$(get_libdir)"
		"INCDIR=${EPREFIX}/usr/include"
	)

	emake "${myemakeargs[@]}" lib-bin
}

src_test() {
	emake VERBOSE=1 XLDFLAGS="-shared" test
}

src_install() {
	local myemakeargs=(
		"VERBOSE=1"
		"PREFIX=${EPREFIX}/usr"
		"DESTDIR=${D}"
		"LIBDIR=${EPREFIX}/usr/$(get_libdir)"
		"INCDIR=${EPREFIX}/usr/include"
		"XLDFLAGS=-shared"
	)

	emake "${myemakeargs[@]}" install

	if [[ ${CHOST} == *-darwin* ]] ; then
		local file="libmpack.0.0.0.dylib"
		install_name_tool \
			-id "${EPREFIX}/usr/$(get_libdir)/${file}" \
			"${ED}/usr/$(get_libdir)/${file}" \
			|| die "Failed to adjust install_name"
	fi

	find "${ED}" -name '*.la' -delete || die
}
