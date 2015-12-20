# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

AUTOTOOLS_AUTORECONF=true

FORTRAN_STANDARD="95"
FORTRAN_NEEDED=fortran

inherit autotools-utils fortran-2 python-single-r1

DESCRIPTION="Reference implementation of the Dirfile, format for time-ordered binary data"
HOMEPAGE="http://getdata.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 debug fortran lzma python perl static-libs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	perl? ( dev-lang/perl )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-serial-test.patch
	"${FILESDIR}"/${P}-out-of-source.patch
	)

src_configure() {
	local myeconfargs=()
	use perl && myeconfargs+=( --with-perl-dir=vendor )
	myeconfargs+=(
		--disable-idl
		--without-libslim
		--with-libz
		--docdir="${EPREFIX}/usr/share/doc/${P}"
		$(use_enable debug)
		$(use_enable fortran)
		$(use_enable fortran fortran95)
		$(use_enable python)
		$(use_enable perl)
		$(use_with bzip2 libbz2)
		$(use_with lzma liblzma)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use python; then
		python_copy_sources
		building() {
			cd "${BUILD_DIR}"/bindings/python || die
			sed "s:-lpython...:$(python_get_LIBS):g" -i Makefile || die
			emake \
				PYTHON_VERSION="${EPYTHON#python}" \
				NUMPY_CPPFLAGS="-I${EPREFIX}$(python_get_sitedir)/numpy/core/include" \
				PYTHON_CPPFLAGS="-I${EPREFIX}$(python_get_includedir)" \
				pyexecdir="${EPREFIX}$(python_get_sitedir)" \
				pythondir="${EPREFIX}$(python_get_sitedir)"
		}
		python_foreach_impl building
	fi
}

src_install() {
	autotools-utils_src_install
	if use python; then
		installation() {
			cd "${BUILD_DIR}"/bindings/python || die
			emake \
				DESTDIR="${D}" \
				PYTHON_VERSION="${EPYTHON#python}" \
				NUMPY_CPPFLAGS="-I${EPREFIX}$(python_get_sitedir)/numpy/core/include" \
				PYTHON_CPPFLAGS="-I${EPREFIX}$(python_get_includedir)" \
				pyexecdir="${EPREFIX}$(python_get_sitedir)" \
				pythondir="${EPREFIX}$(python_get_sitedir)" \
				install
				find \
					"${ED}/$(python_get_sitedir)" \
					-type f \( -name "*.a" -o -name "*.la" \) -delete || die
		}
		python_foreach_impl installation
	fi
}
