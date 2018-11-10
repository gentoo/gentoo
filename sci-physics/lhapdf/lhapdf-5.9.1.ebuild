# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit versionator

MY_PV=$(get_version_component_range 1-3 ${PV})
MY_PF=${PN}-${MY_PV}

DESCRIPTION="Les Houches Parton Density Function unified library"
HOMEPAGE="http://projects.hepforge.org/lhapdf/"
SRC_URI="http://www.hepforge.org/archive/lhapdf/${MY_PF}.tar.gz
	test? (
		http://lhapdf.hepforge.org/svn/pdfsets/5/CT10.LHgrid
		http://lhapdf.hepforge.org/svn/pdfsets/5/cteq61.LHgrid
		http://lhapdf.hepforge.org/svn/pdfsets/5/MRST2004nlo.LHgrid
		http://lhapdf.hepforge.org/svn/pdfsets/5/cteq61.LHpdf
		octave? ( http://lhapdf.hepforge.org/svn/pdfsets/5/cteq5l.LHgrid ) )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cxx doc examples octave python test"

RDEPEND="octave? ( sci-mathematics/octave )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex] )
	python? ( dev-lang/swig )"

S="${WORKDIR}/${MY_PF}"

src_prepare() {
	# do not create extra latex docs
	sed -i \
		-e 's/GENERATE_LATEX.*=YES/GENERATE_LATEX = NO/g' \
		ccwrap/Doxyfile || die
}

src_configure() {
	local myconf="--enable-ccwrap"
	! use octave && ! use cxx && myconf="--disable-ccwrap"
	econf \
		$(use_enable cxx old-ccwrap ) \
		$(use_enable octave) \
		$(use_enable python pyext) \
		$(use_enable doc doxygen) \
		${myconf}
}

src_test() {
	# need to make a bogus link for octave test
	if use octave; then
		# remove line that tries to read non-existent help file
		sed -i -e '/help/d' octave/lhapdf-octave-example1.m \
		|| die 'sed octave example failed'
	fi
	ln -s "${DISTDIR}" PDFsets
	LHAPATH="${PWD}/PDFsets" \
		LD_LIBRARY_PATH="${PWD}/lib/.libs:${LD_LIBRARY_PATH}" \
		emake check
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README TODO AUTHORS ChangeLog

	# leftover
	rm -rf "${D}"/usr/share/${PN}/doc || die
	if use doc && use cxx; then
		# default doc install buggy
		insinto /usr/share/doc/${PF}
		doins -r ccwrap/doxy/html
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.{f,cc}
	fi
}

pkg_postinst() {
	elog "To install data files, you have to run as root:"
	elog "${ROOT}usr/bin/lhapdf-getdata --dest=${ROOT}usr/share/lhapdf/PDFsets --all"
}

pkg_postrm() {
	if [ -d "${ROOT}usr/share/lhapdf" ]; then
		ewarn "The data directory has not been removed, probably because"
		ewarn "you still have installed data files."
	fi
}
