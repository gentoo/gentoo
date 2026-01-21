# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit toolchain-funcs python-single-r1 optfeature

MY_PV=$(ver_cut 1-2)
MY_P="${PN}${PV//./}"
LHA_VER="6.2.1"

DESCRIPTION="Lund Monte Carlo high-energy physics event generator"
HOMEPAGE="https://pythia.org/"
SRC_URI="test? ( lhapdf? (
		https://lhapdfsets.web.cern.ch/lhapdfsets/current/CT10.tar.gz
		https://lhapdfsets.web.cern.ch/lhapdfsets/current/MRST2007lomod.tar.gz
		https://lhapdfsets.web.cern.ch/lhapdfsets/current/NNPDF23_nlo_as_0119_qed_mc.tar.gz
		https://lhapdfsets.web.cern.ch/lhapdfsets/current/NNPDF23_nnlo_as_0119_qed_mc.tar.gz
		https://lhapdfsets.web.cern.ch/lhapdfsets/current/cteq66.tar.gz
		https://lhapdfsets.web.cern.ch/lhapdfsets/current/cteq6l1.tar.gz
		https://www.hepforge.org/downloads/lhapdf/pdfsets/v6.backup/${LHA_VER}/MRST2004qed.tar.gz
	) )
"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/Pythia8/releases"
else
	SRC_URI="https://pythia.org/download/${PN}${MY_PV//./}/${MY_P}.tgz
	${SRC_URI}"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="8"
IUSE="doc examples fastjet +hepmc3 lhapdf root test zlib python highfive mpich rivet static-libs" # evtgen mg5mes rivet powheg
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	fastjet? ( sci-physics/fastjet )
	hepmc3? ( sci-physics/hepmc:3= )
	lhapdf? ( sci-physics/lhapdf:= )
	zlib? ( virtual/zlib:= )
	highfive? (
		sci-libs/highfive
		sci-libs/hdf5[cxx]
	)
	rivet? ( >=sci-physics/rivet-4:* )
	mpich? ( sys-cluster/mpich )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
# ROOT is used only when building related tests
BDEPEND="
	test? (
		root? ( sci-physics/root:= )
	)
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

pkg_pretend() {
	if use root && ! use test; then
		ewarn "ROOT support will only affect examples code build during test stage."
		ewarn "Since you have tests disabled, this is a no-op."
	fi
}

src_prepare() {
	PYTHIADIR="/usr/share/Pythia8"
	EPYTHIADIR="${EPREFIX}${PYTHIADIR}"

	default
	# set datadir for xmldor in include file
	sed -i \
		-e "s|../share/Pythia8/xmldoc|${EPYTHIADIR}/xmldoc|" \
		include/Pythia8/Pythia.h || die
	# respect libdir, prefix, flags
	sed -i \
		-e "s|/lib|/$(get_libdir)|g" \
		-e "s|/usr|${EPREFIX}/usr|g" \
		-e "s|-O2|${CXXFLAGS}|g" \
		-e "s|Cint|Core|g" \
		configure || die
	# we use lhapdf6 instead of lhapdf5
	# some PDFs changed, use something similar
	sed -i \
		-e "s|LHAPDF5|LHAPDF6|g" \
		-e "s|\.LHgrid||g" \
		-e "s|\.LHpdf||g" \
		-e "s|MRST2001lo|MRST2007lomod|g" \
		-e "s|cteq6ll|cteq6l1|g" \
		-e "s|cteq6m|cteq66|g" \
		examples/*.{cc,cmnd} || die
	# After lhapdf5->6 migration PDFs are identical within ~1/1000
	# https|//www.hepforge.org/archive/lhapdf/pdfsets/6.1/README
	sed -i \
		-e "s|1e-8|3e-1|g" \
		-e "s|nlo_as_0119_qed|nlo_as_0119_qed_mc|g" \
		-e "s|xmldoc|share/Pythia8/xmldoc|g" \
		examples/main203.cc || die
	# ask cflags from root
	sed -i "s|root-config|root-config --cflags|g" examples/Makefile || die

	sed -i 's|libpythia8\.a|libpythia8$(LIB_SUFFIX)|g' \
		examples/Makefile || die
}

# TODO: the following optional packages are out of Gentoo tree:
# - EvtGen http://atlas-computing.web.cern.ch/atlas-computing/links/externalDirectory/EvtGen/
# - PowHEG http://powhegbox.mib.infn.it/
# - ProMC  https://github.com/Argonne-National-Laboratory/ProMC/
src_configure() {
	# homemade configure script
	local -x CXX="$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS}"
	./configure \
		--arch=Linux \
		--prefix="${EPREFIX}/usr" \
		--prefix-lib="${EPREFIX}/usr/$(get_libdir)" \
		--prefix-share="${EPYTHIADIR}" \
		$(usex fastjet "--with-fastjet3" "") \
		$(usex zlib "--with-gzip" "") \
		$(use_with hepmc3) \
		$(use_with highfive) \
		$(usex highfive --with-hdf5 "") \
		$(use_with python) \
		$(use_with rivet) \
		$(use_with mpich) \
		$(usex lhapdf "--with-lhapdf6
			--with-lhapdf6-plugin=LHAPDF6.h
			--with-lhapdf6-lib=${EPREFIX}/usr/$(get_libdir)" "") \
		$(usex root "--with-root
			--with-root-include=${EPREFIX}/usr/include/root
			--with-root-lib=${EPREFIX}/usr/$(get_libdir)/root" "") \
		|| die

	# fix pythia config script
	sed -i \
		-e 's|Pythia8/examples/Makefile.inc|Pythia8/Makefile.inc|' \
		-e "s|CFG_FILE=.*|CFG_FILE=${EPYTHIADIR}/Makefile.inc|" \
		-e 's|LINE%=|LINE%%=|' \
		bin/pythia8-config || die
}

src_test() {
	cd examples || die

	local tests="$(echo main{{101..103},{121..127}})"
	use hepmc3 && tests+=" $(echo main{131..135})"
	use hepmc3 && use mpich && use highfive && tests+=" $(echo main136)"
	use lhapdf && tests+=" $(echo main{201..204})"
	use fastjet && tests+=" $(echo main{{211..214},216})" # 215 fails...
	use root && tests+=" main143"
	use hepmc3 && use lhapdf && tests+=" $(echo main{133,162})"
	use fastjet && use hepmc3 && use lhapdf && tests+=" $(echo main161)"
	# Other tests disabled due to missing dependencies

	# use emake for parallel instead of long runmains
	LD_LIBRARY_PATH="${S}/$(get_libdir):${LD_LIBRARY_PATH}" \
	PYTHIA8DATA="../share/Pythia8/xmldoc/" \
	LHAPDF_DATA_PATH="${WORKDIR}" \
	emake ${tests}
	emake clean
}

src_install() {
	# make install is too broken, much easier to install manually
	dobin bin/pythia8-config
	doheader -r include/*
	dolib.so lib/libpythia8.so
	use static-libs && dolib.a lib/libpythia8.a
	use lhapdf && dolib.so lib/libpythia8lhapdf6.so
	insinto "${PYTHIADIR}"
	doins -r share/Pythia8/tunes share/Pythia8/xmldoc share/Pythia8/pdfdata examples/Makefile.inc
	dosym Pythia8 /usr/share/${PN}

	newenvd - 99pythia8 <<- _EOF_
		PYTHIA8DATA=${EPYTHIADIR}/xmldoc
	_EOF_

	dodoc AUTHORS GUIDELINES README

	if use doc; then
		dodoc -r share/Pythia8/pdfdoc/.
		dodoc -r share/Pythia8/htmldoc/.
	fi
	if use examples; then
		sed -i "s|include Makefile.inc|include ${EPYTHIADIR}|" \
			examples/Makefile || die

		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	if use python; then
		local site_dir=$(python_get_sitedir)
		insinto "${site_dir#${EPREFIX}}"
		doins lib/pythia8.so
	fi

	# cleanup
	unset PYTHIADIR EPYTHIADIR
}

pkg_postinstall() {
	optfeature "python interface awkward array support" dev-python/awkward
	optfeature "python interface vector support" dev-python/vector
}
