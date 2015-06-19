# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ccp4-apps/ccp4-apps-6.1.3-r13.ebuild,v 1.5 2015/05/05 08:53:26 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils fortran-2 flag-o-matic gnuconfig python-single-r1 toolchain-funcs

MY_P="${PN/-apps}-${PV}"

#UPDATE="04_03_09"
#PATCHDATE="090511"

PATCH_TOT="0"

DESCRIPTION="Protein X-ray crystallography toolkit"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC="ftp://ftp.ccp4.ac.uk/ccp4"
SRC_URI="
	${SRC}/${PV}/${MY_P}-core-src.tar.gz
	http://dev.gentoo.org/~jlec/distfiles/${PV}-oasis4.0.patch.bz2"
# patch tarball from upstream
	[[ -n ${UPDATE} ]] && SRC_URI="${SRC_URI} ${SRC}/${PV}/updates/${P}-src-patch-${UPDATE}.tar.gz"
# patches created by us
	[[ -n ${PATCHDATE} ]] && SRC_URI="${SRC_URI} http://dev.gentoo.org/~jlec/science-dist/${PV}-${PATCHDATE}-updates.patch.bz2"

for i in $(seq $PATCH_TOT); do
	NAME="PATCH${i}[1]"
	SRC_URI="${SRC_URI}
		${SRC}/${PV}/patches/${!NAME}"
done

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="examples X"

X11DEPS="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt
	x11-libs/libxdl_view"

TKDEPS="
	>=dev-lang/tk-8.3:0=
	>=dev-tcltk/blt-2.4
	dev-tcltk/iwidgets
	dev-tcltk/itcl
	dev-tcltk/itk
	>=dev-tcltk/tdom-0.8
	dev-tcltk/tktreectrl"

SCILIBS="
	~sci-libs/ccp4-libs-${PV}
	>=sci-libs/ccp4-libs-${PV}-r7
	sci-libs/clipper
	sci-libs/fftw:2.1
	sci-libs/mmdb:0
	sci-libs/ssm
	virtual/blas
	virtual/lapack"

SCIAPPS="
	sci-chemistry/pdb-extract
	sci-chemistry/pymol
	sci-chemistry/rasmol
	>=sci-chemistry/oasis-4.0-r1"

RDEPEND="
	${TKDEPS}
	${SCILIBS}
	app-shells/tcsh
	dev-python/pyxml
	dev-libs/libxml2:2
	dev-libs/libjwc_c
	dev-libs/libjwc_f
	dev-libs/boehm-gc
	!app-office/sc
	!<sci-chemistry/ccp4-6.1.3
	X? ( ${X11DEPS} )"
DEPEND="${RDEPEND}
	X? (
		x11-misc/imake
		x11-proto/inputproto
		x11-proto/xextproto
	)"
PDEPEND="${SCIAPPS}"

RESTRICT="mirror"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	fortran-2_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	tc-export PKG_CONFIG
	einfo "Applying upstream patches ..."
	for patch in $(seq $PATCH_TOT); do
		base="PATCH${patch}"
		dir=$(eval echo \${${base}[0]})
		p=$(eval echo \${${base}[1]})
		pushd "${dir}" >& /dev/null
		ccp_patch "${DISTDIR}/${p}"
		popd >& /dev/null
	done
	einfo "Done."
	echo

	[[ -n ${PATCHDATE} ]] && epatch "${WORKDIR}"/${PV}-${PATCHDATE}-updates.patch

	einfo "Applying Gentoo patches ..."

	# it tries to create libdir, bindir etc on live system in configure
	ccp_patch "${FILESDIR}"/${PV}-dont-make-dirs-in-configure.patch

	# We already have sci-chemistry/rasmol
	# Also remember to create the bindir.
	ccp_patch "${FILESDIR}"/${PV}-dont-build-double-and-make-bindir.patch

	# libraries come from sci-libs/ccp4-libs
	ccp_patch "${FILESDIR}"/${PV}-dont-build-libs.patch

	# We have seperate ebuilds for those
	for bin in molref xia scala imosflm balbes; do
		ccp_patch "${FILESDIR}"/${PV}-dont-build-${bin}.patch
	done

	# don't configure what is not build
	ccp_patch "${FILESDIR}"/${PV}-dont-configure.patch

	# Set python paths correctly
	ccp_patch "${FILESDIR}"/${PV}-pythonpath.patch

	# Set python paths correctly
	ccp_patch "${FILESDIR}"/${PV}-pisa.patch

	# Set python paths correctly
	ccp_patch "${FILESDIR}"/${PV}-clipper-template.patch

	# Fix upstreams code
	ccp_patch "${FILESDIR}"/${PV}-impl-dec.patch

	# Not renaming, but unbundling libs
	ccp_patch "${FILESDIR}"/${PV}-rename-rapper-ng.patch

	# Use pkg-config to detect BLAS/LAPCK
	ccp_patch "${FILESDIR}"/${PV}-lapack.patch

	# unbundle libs
	ccp_patch "${FILESDIR}"/${PV}-unbundle.patch

	# tcl-8.6
	ccp_patch "${FILESDIR}"/${P}-tcl8.6.patch

	# Update things for oasis 4 usage
	epatch "${WORKDIR}"/${PV}-oasis4.0.patch
	sed 's: oasis : :g' -i src/Makefile.in || die

	einfo "Done." # done applying Gentoo patches
	echo

	find ./lib/src/mmdb ./lib/ssm ./lib/clipper ./lib/fftw lib/lapack -delete

	sed \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-e 's:-Wl,-rpath,$CLIB::g' \
		-e 's: -rpath $CLIB::g' \
		-e 's: -I${srcdir}/include/cpp_c_headers::g' \
		-e 's:sleep 1:sleep .2:g' \
		-e 's:\\$(XCIF_LIB):-L$srcdir/lib/ccif -lccif:g' \
		-e 's:\\$(XLAPACK_LIB):${XLAPACK_LIB}:g' \
		-e 's:\\$(CXX_LIBS):\${CXX_LIBS}:g' \
		-e 's:\\$(XLDFLAGS):\${XLDFLAGS}:g' \
		-i configure || die

	sed \
		-e '/o crunch2/s:$: ${XLAPACK_LIB}:g' \
		-i src/Makefile* || die

	find "${S}" -name "Makefile.*" \
		-exec sed -e 's|_FLAGS-|_FLAGS:-|g' -e "s:\(eval \$([[:alnum:]]*)\):\1 \$(GENTOOLDFLAGS):g" -i '{}' \;

	# Don't build refmac, sfcheck, balbes, molrep binaries; available from the standalone version
	sed -i -e "/^REFMACTARGETS/s:^.*:REFMACTARGETS="":g" configure || die

	# Rapper bundles libxml2 and boehm-gc. Don't build, use or install those.
	pushd src/rapper 2>/dev/null
		eautoreconf
	popd 2>/dev/null

	gnuconfig_update

	python_fix_shebang -f .
}

src_configure() {
	# Build system is broken if we set LDFLAGS
	export GENTOOLDFLAGS="${LDFLAGS}"
	unset LDFLAGS

	# These are broken with ./src/procheck/ps.f
	filter-flags "-floop-*"

	# GENTOO_OSNAME can be one of:
	# irix irix64 sunos sunos64 aix hpux osf1 linux freebsd
	# linux_compaq_compilers linux_intel_compilers generic Darwin
	# ia64_linux_intel Darwin_ibm_compilers linux_ibm_compilers
	if [[ "$(tc-getFC)" = "ifort" ]]; then
		if use ia64; then
			GENTOO_OSNAME="ia64_linux_intel"
		else
			# Should be valid for x86, maybe amd64
			GENTOO_OSNAME="linux_intel_compilers"
		fi
	else
		# Should be valid for x86 and amd64, at least
		GENTOO_OSNAME="linux"
	fi

	# Sets up env
	ln -s \
		ccp4.setup-bash \
		"${S}"/include/ccp4.setup

	# We agree to the license by emerging this, set in LICENSE
	sed -i \
		-e "s~^\(^agreed=\).*~\1yes~g" \
		"${S}"/configure || die

	# Fix up variables -- need to reset CCP4_MASTER at install-time
	sed -i \
		-e "s~^\(setenv CCP4_MASTER.*\)/.*~\1${WORKDIR}~g" \
		-e "s~^\(export CCP4_MASTER.*\)/.*~\1${WORKDIR}~g" \
		-e "s~^\(.*export CBIN=.*\)\$CCP4.*~\1\$CCP4/libexec/ccp4/bin/~g" \
		-e "s~^\(.*setenv CBIN .*\)\$CCP4.*~\1\$CCP4/libexec/ccp4/bin/~g" \
		-e "s~^\(setenv CCP4I_TCLTK.*\)/usr/local/bin~\1${EPREFIX}/usr/bin~g" \
		"${S}"/include/ccp4.setup* || die

	# Set up variables for build
	source "${S}"/include/ccp4.setup-sh

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export COPTIM=${CFLAGS}
	export CXXOPTIM=${CXXFLAGS}
	# Default to -O2 if FFLAGS is unset
	export FC=$(tc-getFC)
	export FOPTIM=${FFLAGS:- -O2}
	export BINSORT_SCR="${T}"
	export CCP4_MASTER="${WORKDIR}"
	export CCP4I_TCLTK="${EPREFIX}/usr/bin"
	export MAKE="make ${MAKEOPTS} ${EXTRA_EMAKE}"

	# Can't use econf, configure rejects unknown options like --prefix
	./configure \
		$(use_enable X x) \
		--with-shared-libs \
		--with-fftw="${EPREFIX}/usr" \
		--with-warnings \
		--disable-pdb_extract \
		--disable-cctbx \
		--disable-phaser \
		--disable-diffractionImg \
		--disable-clipper \
		--disable-ssm \
		--disable-mosflm \
		--disable-mrbump \
		--tmpdir="${TMPDIR}" \
		${GENTOO_OSNAME} || die "configure failed"

	# We do this manually, since disabling the clipper libraries also
	# disables the clipper programs
	pushd src/clipper_progs 2>/dev/null
	econf \
		--prefix="${S}" \
		--bindir="${ED}"/usr/libexec/ccp4/bin \
		--with-ccp4="${S}" \
		--with-clipper="${EPREFIX}/usr" \
		--with-fftw="${EPREFIX}/usr" \
		--with-mmdb="${EPREFIX}/usr" \
		CXX=$(tc-getCXX)
	popd 2>/dev/null
}

src_compile() {
	# fsplit is required for the programs
	pushd lib/src 2>/dev/null
		emake fsplit -j1 || die
	popd 2>/dev/null

	# We do this manually, since disabling the clipper libraries also
	# disables the clipper programs
	pushd src/clipper_progs 2>/dev/null
		emake || die
	popd 2>/dev/null

	emake -j1 || die "emake failed"
}

src_install() {
	# Set up variables for build
	source "${S}"/include/ccp4.setup-sh

	# if we don't make this, a ton of programs fail to install
	mkdir "${S}"/bin || die

	# We do this manually, since disabling the clipper libraries also
	# disables the clipper programs
	pushd "${S}"/src/clipper_progs 2>/dev/null
		emake install || die
	popd 2>/dev/null

	einstall || die "install failed"

	# Collision with sci-chemistry/mrbump
	rm -f "${S}"/bin/{mrbump,pydbviewer} || die

	# Bins
	exeinto /usr/libexec/ccp4/bin/
	doexe "${S}"/bin/* || die

	# Libs
	for file in "${S}"/lib/*; do
		if [[ -d ${file} ]]; then
			continue
		elif [[ -x ${file} ]]; then
			dolib.so ${file} || die
		else
			insinto /usr/$(get_libdir)
			doins ${file} || die
		fi
	done

	rm -f "${S}"/include/ccp4.setup*

	# smartie -- log parsing
	insinto /usr/share/ccp4
	doins -r "${S}"/share/smartie || die

	# Install docs and examples
	local _man
	pushd "${S}"/man/cat1 > /dev/null
	for _man in *; do
		newman ${_man} ${_man%??}-ccp4${_man:${#_man}-2:2}
	done
	popd > /dev/null

	mv "${S}"/manual/README "${S}"/manual/README-manual
	dodoc manual/* README CHANGES doc/* examples/README || die

	rm "${ED}"/usr/share/doc/${PF}/GNUmakefile.*
	rm "${ED}"/usr/share/doc/${PF}/COPYING.*

	dohtml -r "${S}"/html/*

	if use examples; then
		for i in data rnase toxd; do
			docinto examples/${i}
			dodoc "${S}"/examples/${i}/*
		done

		docinto examples/tutorial
		dohtml -r "${S}"/examples/tutorial/html examples/tutorial/tut.css
		for i in data results; do
			docinto examples/tutorial/${i}
			dodoc "${S}"/examples/tutorial/${i}/*
		done

		for i in non-runnable runnable; do
			docinto examples/unix/${i}
			dodoc "${S}"/examples/unix/${i}/*
		done
	fi
	# Needed for ccp4i docs to work
	dosym ../../share/doc/${PF}/examples /usr/$(get_libdir)/ccp4/examples || die
	dosym ../../share/doc/${PF}/html /usr/$(get_libdir)/ccp4/html || die

	cat >> "${T}"/baubles <<- EOF
	#!${EPREFIX}/bin/bash
	exec "${EPYTHON}" "\${CCP4}/share/ccp4/smartie/baubles.py"
	EOF

	exeinto /usr/libexec/ccp4/bin/
	doexe "${T}"/baubles || die
}

# Epatch wrapper for bulk patching
ccp_patch() {
	EPATCH_SINGLE_MSG="  ${1##*/} ..." epatch ${1}
}
