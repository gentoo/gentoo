# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic python-single-r1 toolchain-funcs

CCP4VER="6.1.13"

DESCRIPTION="A program for phasing macromolecular crystal structures"
HOMEPAGE="http://www-structmed.cimr.cam.ac.uk/phaser"
SRC_URI="ftp://ftp.ccp4.ac.uk/ccp4/${CCP4VER}/ccp4-${CCP4VER}-${PN}-cctbx-src.tar.gz"

LICENSE="|| ( phaser phaser-com ccp4 )"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE="openmp"

RDEPEND=""
DEPEND="${RDEPEND}
		  app-shells/tcsh"

S="${WORKDIR}"/ccp4-${CCP4VER}

src_prepare() {
	epatch \
		"${FILESDIR}"/phaser-2.1.4-chmod.patch \
		"${FILESDIR}"/phaser-2.1.4-ldflags.patch

	use openmp && append-flags -fopenmp

	for i in ${CXXFLAGS}; do
		OPTS="${OPTS} \"${i}\","
	done

	OPTS=${OPTS%,}

	sed -i \
		-e "s:opts = \[.*\]$:opts = \[${OPTS}\]:g" \
		"${S}"/lib/cctbx/cctbx_sources/libtbx/SConscript || die

	for i in ${LDFLAGS}; do
		OPTSLD="${OPTSLD} \"${i}\","
	done

	sed -i \
		-e "s:env_etc.shlinkflags .* \"-shared\":env_etc.shlinkflags = \[ ${OPTSLD} \"-shared\"\]:g" \
		-e "s:\[\"-static:\[${OPTSLD} \"-static:g" \
		"${S}"/lib/cctbx/cctbx_sources/libtbx/SConscript || die

}

src_configure() {
	local compiler
	local mtype
	local mversion
	local nproc

	# Valid compilers are win32_cl, sunos_CC, unix_gcc, unix_ecc,
	# unix_icc, unix_icpc, tru64_cxx, hp_ux11_aCC, irix_CC,
	# darwin_c++, darwin_gcc.  The build systems seems to prepend
	# unix_ all by itself.  Can this be derived from $(tc-getCC)?
	compiler=$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')

	# Breaks cross compilation.
	mtype=$(src/${PN}/bin/machine_type)
	mversion=$(src/${PN}/bin/machine_version)

	einfo "Creating build directory"
	mkdir build
	cd build
	ln -sf "${S}/lib/cctbx/cctbx_sources/scons"  scons
	ln -sf "${S}/lib/cctbx/cctbx_sources/libtbx" libtbx

	einfo "Configuring phaser components"
	$(PYTHON) "libtbx/configure.py" \
		--build=release \
		--compiler=${compiler} \
		--repository="${S}"/src/${PN}/source \
		--repository="${S}"/lib/cctbx/cctbx_sources \
		--static_libraries \
		ccp4io="${S}" \
		mmtbx \
		phaser || die "configure.py failed"
}

src_compile() {
	nproc=`echo "-j1 ${MAKEOPTS}" \
		| sed -e "s/.*\(-j\s*\|--jobs=\)\([0-9]\+\).*/\2/"`

	cd build
	einfo "Setting up build environment"
	source setpaths.sh

	einfo "Compiling phaser components"
	libtbx.scons -j ${nproc} || die "libtbx.scons failed"
}

src_install() {
	dobin build/exe/phaser || die

	cat >> "${T}"/53${PN} <<- EOF
	PHASER="${EPREFIX}/usr/bin"
	PHASER_ENVIRONMENT="1"
	PHASER_MTYPE="${mtype}"
	PHASER_MVERSION="${mversion}"
	PHASER_VERSION="${PV}"
	EOF

	doenvd "${T}"/53${PN} || die
}
