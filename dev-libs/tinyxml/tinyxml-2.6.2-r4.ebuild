# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs multilib

DESCRIPTION="Simple and small C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV//./_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-macos"
IUSE="debug doc static-libs +stl"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

DOCS=( "changes.txt" "readme.txt" )

src_prepare() {
	local major_v=$(ver_cut 1)
	local minor_v=$(ver_cut 2-3)

	sed -e "s:@MAJOR_V@:$major_v:" \
	    -e "s:@MINOR_V@:$minor_v:" \
		"${FILESDIR}"/Makefile-3 > Makefile || die

	eapply -p0 "${FILESDIR}"/${PN}-2.6.1-entity.patch
	eapply -p0 "${FILESDIR}"/${PN}.pc.patch

	use debug && append-cppflags -DDEBUG
	use stl && eapply "${FILESDIR}"/${P}-defineSTL.patch

	sed -e "s:/lib:/$(get_libdir):g" -i tinyxml.pc || die # bug 738948
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

	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r docs/*
	fi
}
