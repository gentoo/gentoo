# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic

DESCRIPTION="research tool for polyhedral geometry and combinatorics"
SRC_URI="https://polymake.org/lib/exe/fetch.php/download/polymake-3.0r2.tar.bz2"
HOMEPAGE="http://polymake.org"

IUSE="+cdd lrs ppl bliss group +libnormaliz singular libpolymake"

REQUIRED_USE="group? ( cdd lrs )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-lang/perl
	dev-libs/gmp:0=
	dev-libs/mpfr:0
	dev-libs/libxml2:2
	dev-libs/libxslt
	ppl? ( dev-libs/ppl )
	cdd? ( sci-libs/cddlib )
	lrs? ( >=sci-libs/lrslib-051[gmp] )
	bliss? ( sci-libs/bliss[gmp] )
	group? ( dev-libs/boost:= )
	libnormaliz? ( dev-libs/boost:= )
	singular? ( >=sci-mathematics/singular-4.0.1 )"
RDEPEND="${DEPEND}
	dev-perl/XML-LibXML
	dev-perl/XML-LibXSLT
	dev-perl/XML-Writer
	dev-perl/Term-ReadLine-Gnu"

S="${WORKDIR}/${PN}-3.0"

pkg_pretend() {
	einfo "During compile this package uses up to"
	einfo "750MB of RAM per process. Use MAKEOPTS=\"-j1\" if"
	einfo "you run into trouble."
}

src_configure () {
	export CXXOPT=$(get-flag -O)

	# We need to define BLISS_USE_GMP if bliss was built with gmp support.
	# Therefore we require gmp support on bliss, so that the package
	# manager can prevent rebuilds with changed gmp flag.
	if use bliss ; then
		append-cxxflags -DBLISS_USE_GMP
	fi

	# Configure does not accept --host, therefore econf cannot be used

	# Some of the options do not support using just '--with-option'
	local myconf=""
	use !group && myconf="$myconf --without-group"
	use !libnormaliz && myconf="$myconf --without-libnormaliz"
	use !libpolymake && myconf="$myconf --without-callable"

	# And many other --with-arguments expect a path: --with-option=/path
	./configure --prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--libexecdir="${EPREFIX}/usr/$(get_libdir)/polymake" \
		--without-prereq \
		--without-java \
		$(use_with cdd cdd "${EPREFIX}/usr") \
		$(use_with lrs lrs "${EPREFIX}/usr") \
		$(use_with ppl ppl "${EPREFIX}/usr") \
		$(use_with bliss bliss "${EPREFIX}/usr") \
		$(use_with singular singular "${EPREFIX}/usr") \
		${myconf} || die
}

src_install(){
	emake -j1 DESTDIR="${D}" install
}

pkg_postinst(){
	elog "Docs can be found on http://www.polymake.org/doku.php/documentation"
	elog " "
	elog "Support for jreality is missing, sorry (see bug #346073)."
	elog " "
	elog "Additional features for polymake are available through external"
	elog "software such as sci-mathmatics/4ti2 and sci-mathematics/topcom."
	elog "After installing new external software run 'polymake --reconfigure'."
}
