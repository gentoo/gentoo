# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/metakit/metakit-2.4.9.7-r2.ebuild,v 1.6 2015/03/28 21:33:28 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic multilib python-single-r1 toolchain-funcs

DESCRIPTION="Embedded database library"
HOMEPAGE="http://www.equi4.com/metakit/"
SRC_URI="http://www.equi4.com/pub/mk/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="python static tcl"

DEPEND="
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )"
RDEPEND="${DEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="test"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-linking.patch \
		"${FILESDIR}"/${P}-tcltk86.patch
}

src_configure() {
	local myconf mycxxflags
	use tcl && myconf+=" --with-tcl=${EPREFIX}/usr/include,${EPREFIX}/usr/$(get_libdir)"
	use static && myconf+=" --disable-shared"
	use static || append-cxxflags -fPIC

	CXXFLAGS="${CXXFLAGS} ${mycxxflags}" unix/configure \
		${myconf} \
		--host=${CHOST} \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--infodir="${EPREFIX}/usr/share/info" \
		--mandir="${EPREFIX}/usr/share/man"
}

src_compile() {
	emake SHLIB_LD="$(tc-getCXX) -shared -Wl,-soname,libmk4.so.2.4"

	if use python; then
		emake \
			SHLIB_LD="$(tc-getCXX) -shared" \
			pyincludedir="$(python_get_includedir)" \
			PYTHON_LIB="-l${EPYTHON}" \
			python
	fi
}

src_install () {
	default

	mv "${ED}"//usr/$(get_libdir)/libmk4.so{,.2.4}
	dosym libmk4.so.2.4 /usr/$(get_libdir)/libmk4.so.2
	dosym libmk4.so.2.4 /usr/$(get_libdir)/libmk4.so

	if use python; then
		mkdir -p "${D%/}$(python_get_sitedir)" || die
		emake \
			DESTDIR="${D}" \
			pylibdir="$(python_get_sitedir)" \
			install-python
	fi

	dohtml Metakit.html
	dohtml -a html,gif,png,jpg -r doc/*
}
