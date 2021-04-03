# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs multilib versionator

DESCRIPTION="Simple and small C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV//./_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~x64-macos"
IUSE="debug doc static-libs +stl"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

src_prepare() {
	local major_v=$(get_major_version)
	local minor_v=$(get_version_component_range 2-3)

	sed -e "s:@MAJOR_V@:$major_v:" \
	    -e "s:@MINOR_V@:$minor_v:" \
		"${FILESDIR}"/Makefile-3 > Makefile || die

	epatch "${FILESDIR}"/${PN}-2.6.1-entity.patch
	epatch "${FILESDIR}"/${PN}.pc.patch

	use debug && append-cppflags -DDEBUG
	use stl && epatch "${FILESDIR}"/${P}-defineSTL.patch

	if use stl; then
		sed -e "s/Cflags: -I\${includedir}/Cflags: -I\${includedir} -DTIXML_USE_STL=YES/g" -i tinyxml.pc || die
	fi

	if ! use static-libs; then
		sed -e "/^all:/s/\$(name).a //" -i Makefile || die
	fi

	tc-export AR CXX RANLIB

	[[ ${CHOST} == *-darwin* ]] && export LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	eapply_user
}

src_install() {
	dolib.so *$(get_libname)*

	insinto /usr/include
	doins *.h

	insinto /usr/share/pkgconfig
	doins tinyxml.pc

	dodoc {changes,readme}.txt

	use doc && dohtml -r docs/*
}
