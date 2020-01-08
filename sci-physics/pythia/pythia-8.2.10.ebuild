# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs versionator

MV=$(get_major_version)
MY_P=${PN}$(replace_all_version_separators "" ${PV})
LHA_VER="6.1"

DESCRIPTION="Lund Monte Carlo high-energy physics event generator"
HOMEPAGE="http://pythia8.hepforge.org/"
SRC_URI="http://home.thep.lu.se/~torbjorn/${PN}${MV}/${MY_P}.tgz
	test? ( lhapdf? (
		https://www.hepforge.org/archive/lhapdf/pdfsets/${LHA_VER}/CT10.tar.gz
		https://www.hepforge.org/archive/lhapdf/pdfsets/${LHA_VER}/MRST2007lomod.tar.gz
		https://www.hepforge.org/archive/lhapdf/pdfsets/${LHA_VER}/NNPDF23_nlo_as_0119_qed_mc.tar.gz
		https://www.hepforge.org/archive/lhapdf/pdfsets/${LHA_VER}/NNPDF23_nnlo_as_0119_qed_mc.tar.gz
		https://www.hepforge.org/archive/lhapdf/pdfsets/${LHA_VER}/cteq66.tar.gz
		https://www.hepforge.org/archive/lhapdf/pdfsets/${LHA_VER}/cteq6l1.tar.gz
		https://www.hepforge.org/archive/lhapdf/pdfsets/${LHA_VER}/unvalidated/MRST2004qed.tar.gz
	) )"

SLOT="8"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples gzip +hepmc fastjet lhapdf root static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	fastjet? ( >=sci-physics/fastjet-3 )
	gzip? ( sys-libs/zlib )
	hepmc? ( sci-physics/hepmc:0= )
	lhapdf? ( >=sci-physics/lhapdf-6:= )
"
# ROOT is used only when building related tests
DEPEND="${RDEPEND}
	test? ( root? ( sci-physics/root:= ) )
"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if use root && ! use test; then
		ewarn "ROOT support will only affect examples code build during test stage."
		ewarn "Since you have tests disabled, this is a no-op."
	fi
}

src_prepare() {
	PYTHIADIR="/usr/share/pythia8"
	EPYTHIADIR="${EPREFIX}${PYTHIADIR}"
	# set datadir for xmldor in include file
	sed -i \
		-e "s:../share/Pythia8/xmldoc:${EPYTHIADIR}/xmldoc:" \
		include/Pythia8/Pythia.h || die
	# respect libdir, prefix, flags
	sed -i \
		-e "s:/lib:/$(get_libdir):g" \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-e "s:-O2:${CXXFLAGS}:g" \
		-e "s:Cint:Core:g" \
		configure || die
	sed -i 's:$(CXX) $^ -o $@ $(CXX_COMMON) $(CXX_SHARED):$(CXX) $(LDFLAGS) $^ -o $@ $(CXX_COMMON) $(CXX_SHARED):g' \
		Makefile || die
	sed -i 's:$(CXX):$(CXX) $(LDFLAGS):' examples/Makefile || die
	# we use lhapdf6 instead of lhapdf5
	# some PDFs changed, use something similar
	sed -i \
		-e "s:LHAPDF5:LHAPDF6:g" \
		-e "s:\.LHgrid::g" \
		-e "s:\.LHpdf::g" \
		-e "s:MRST2001lo:MRST2007lomod:g" \
		-e "s:cteq6ll:cteq6l1:g" \
		-e "s:cteq6m:cteq66:g" \
		examples/*.{cc,cmnd} || die
	# After lhapdf5->6 migration PDFs are identical within ~1/1000
	# https://www.hepforge.org/archive/lhapdf/pdfsets/6.1/README
	sed -i \
		-e "s:1e-8:3e-1:g" \
		-e "s:nlo_as_0119_qed:nlo_as_0119_qed_mc:g" \
		-e "s:xmldoc:share/Pythia8/xmldoc:g" \
		examples/main54.cc || die
	# ask cflags from root
	sed -i "s:root-config:root-config --cflags:g" examples/Makefile || die
	if ! use static-libs; then
		sed -i \
			-e '/TARGETS=$(LOCAL_LIB)\/libpythia8\.a/d' \
			-e 's:libpythia8\.a$:libpythia8\.so$:g' \
			Makefile || die
		sed -i 's:libpythia8\.a:libpythia8\.so:g' \
			examples/Makefile || die
	fi

	epatch "${FILESDIR}/${PN}8209-run-tests.patch"
	epatch "${FILESDIR}/${PN}8209-root-noninteractive.patch"
}

# TODO: the following optional packages are out of Gentoo tree:
# - EvtGen http://atlas-computing.web.cern.ch/atlas-computing/links/externalDirectory/EvtGen/
# - PowHEG http://powhegbox.mib.infn.it/
# - ProMC  https://github.com/Argonne-National-Laboratory/ProMC/
src_configure() {
	# homemade configure script
	./configure \
		--arch=Linux \
		--cxx=$(tc-getCXX) \
		--enable-shared \
		--prefix="${EPREFIX}/usr" \
		--prefix-lib="$(get_libdir)" \
		--prefix-share="${EPYTHIADIR}" \
		$(usex fastjet "--with-fastjet3" "") \
		$(usex gzip "--with-gzip" "") \
		$(usex hepmc "--with-hepmc2" "") \
		$(usex lhapdf "--with-lhapdf6
			--with-lhapdf6-plugin=LHAPDF6.h
			--with-lhapdf6-lib=${EPREFIX}/usr/$(get_libdir)" "") \
		$(usex root "--with-root
			--with-root-include=${EPREFIX}/usr/include/root
			--with-root-lib=${EPREFIX}/usr/$(get_libdir)/root" "") \
		|| die

	# fix pythia config script
	sed -i \
		-e 's:pythia8/examples/Makefile.inc:pythia8/Makefile.inc:' \
		-e 's:LINE%=:LINE%%=:' \
		bin/pythia8-config || die
}

src_test() {
	cd examples || die

	local tests="$(echo main{{01..32},37,38,61,62,73,80}.out)"
	use hepmc && tests+=" $(echo main{41,42,85,86}.out)"
	use hepmc && use lhapdf && tests+=" $(echo main{43,{87..89}}.out)"
	use lhapdf && tests+=" $(echo main{51..54}.out)"
	use fastjet && tests+=" $(echo main{71,72}.out)"
	use fastjet && use hepmc && use lhapdf && tests+=" $(echo main{81..84}).out"
	use root && tests+=" main91.out"
	# Disabled tests:
	# 33	needs PowHEG
	# 46	needs ProMC
	# 48	needs EvtGen
	# 92	generated ROOT dictionary is badly broken

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
	dolib lib/*
	insinto "${PYTHIADIR}"
	doins -r share/Pythia8/xmldoc examples/Makefile.inc

	echo "PYTHIA8DATA=${EPYTHIADIR}/xmldoc" >> 99pythia8
	doenvd 99pythia8

	dodoc AUTHORS GUIDELINES README
	if use doc; then
		dodoc share/Pythia8/pdfdoc/*
		dohtml -r share/Pythia8/htmldoc/*
	fi
	if use examples; then
		# reuse system Makefile.inc
		rm examples/Makefile.inc || die
		sed -i "s:include Makefile.inc:include ${EPYTHIADIR}:" \
			examples/Makefile || die

		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	# cleanup
	unset PYTHIADIR EPYTHIADIR
}
