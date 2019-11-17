# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib toolchain-funcs

MY_PN="${PN}src"

DESCRIPTION="Uncompress rar files"
HOMEPAGE="https://www.rarlab.com/rar_add.htm"
SRC_URI="https://www.rarlab.com/rar/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="unRAR"
# subslot = soname version
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="!<=app-arch/unrar-gpl-0.0.1_p20080417"

S="${WORKDIR}/unrar"

PATCHES=(
	"${FILESDIR}"/${PN}-5.5.5-build.patch
	"${FILESDIR}"/${PN}-5.5.5-honor-flags.patch
)

src_prepare() {
	default

	local sed_args=( -e "/libunrar/s:.so:$(get_libname ${PV%.*.*}):" )
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed_args+=( -e "s:-shared:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libunrar$(get_libname ${PV%.*.*}):" )
	else
		sed_args+=( -e "s:-shared:& -Wl,-soname -Wl,libunrar$(get_libname ${PV%.*.*}):" )
	fi
	sed -i "${sed_args[@]}" makefile || die
}

src_configure() {
	mkdir -p build-{lib,bin}
	printf 'VPATH = ..\ninclude ../makefile' > build-lib/Makefile || die
	cp build-{lib,bin}/Makefile || die
}

src_compile() {
	unrar_make() {
		emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" STRIP=true "$@"
	}

	unrar_make CXXFLAGS+=" -fPIC" -C build-lib lib
	ln -s libunrar$(get_libname ${PV%.*.*}) build-lib/libunrar$(get_libname) || die
	ln -s libunrar$(get_libname ${PV%.*.*}) build-lib/libunrar$(get_libname ${PV}) || die

	unrar_make -C build-bin
}

src_install() {
	dobin build-bin/unrar
	dodoc readme.txt

	dolib.so build-lib/libunrar*

	insinto /usr/include/libunrar${PV%.*.*}
	doins *.hpp
	dosym libunrar${PV%.*.*} /usr/include/libunrar

	find "${ED}" -type f -name "*.a" -delete || die
}
