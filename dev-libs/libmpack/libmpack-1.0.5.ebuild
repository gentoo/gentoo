# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple implementation of msgpack in C"
HOMEPAGE="https://github.com/libmpack/libmpack"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~x64-macos"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default

	# Make compiling verbose
	sed -e 's/@$(LIBTOOL)/$(LIBTOOL)/g' -i Makefile || die

	# Respect users CFLAGS
	sed -e 's/-ggdb//g' -i Makefile || die
	sed -e 's/-O3//g' -i .config/release.mk || die
}

src_compile() {
	local myemakeargs=(
		"PREFIX=/usr"
		"CC=$(tc-getCC)"
		"config=release"
		"LIBDIR=/usr/$(get_libdir)"
	)

	emake "${myemakeargs[@]}" lib-bin
}

src_test() {
	emake XLDFLAGS="-shared" test
}

src_install() {
	local myemakeargs=(
		"PREFIX=/usr"
		"DESTDIR=${ED}"
		"LIBDIR=/usr/$(get_libdir)"
		"XLDFLAGS=-shared"
	)

	emake "${myemakeargs[@]}" install

	if [[ ${CHOST} == *-darwin* ]] ; then
        local file="libmpack.0.0.0.dylib"
        install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/${file}" "${ED}/usr/$(get_libdir)/${file}" || die "Failed to adjust install_name"
    fi

	find "${ED}" -name '*.la' -delete || die
}
