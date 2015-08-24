# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils fortran-2 gnuconfig multilib python-single-r1 toolchain-funcs

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

#UPDATE="04_03_09"
#PATCHDATE="090511"

MY_P="${P/-libs}"

PATCH_TOT="0"

DESCRIPTION="Protein X-ray crystallography toolkit - Libraries"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="${SRC}/${PV}/${MY_P}-core-src.tar.gz"
# patch tarball from upstream
	[[ -n ${UPDATE} ]] && SRC_URI="${SRC_URI} ${SRC}/${PV}/updates/${P}-src-patch-${UPDATE}.tar.gz"
# patches created by us
	[[ -n ${PATCHDATE} ]] && SRC_URI="${SRC_URI} https://dev.gentoo.org/~jlec/science-dist/${PV}-${PATCHDATE}-updates.patch.bz2"

for i in $(seq $PATCH_TOT); do
	NAME="PATCH${i}[1]"
	SRC_URI="${SRC_URI}
		${SRC}/${PV}/patches/${!NAME}"
done

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="minimal"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	!<sci-chemistry/ccp4-6.1.3
	!<sci-chemistry/ccp4-apps-${PV}-r10
	app-shells/tcsh
	dev-lang/tcl:0
	>=sci-libs/cbflib-0.9.2.2
	sci-libs/fftw:2.1
	sci-libs/mmdb:0
	sci-libs/monomer-db
	sci-libs/ssm
	virtual/jpeg:0=
	virtual/lapack
	virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

MAKEOPTS+=" -j1"

pkg_setup() {
	fortran-2_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	tc-export PKG_CONFIG RANLIB AR

	sed \
		-e "/^AR/s:ar:$(tc-getAR):g" \
		-i lib/src/Makefile.in src/Makefile.in src/ccp4mapwish_/Makefile.in lib/ccif/Makefile.in || die

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
	# fix buffer overflows wrt bug 339706
	ccp_patch "${FILESDIR}"/${PV}-overflows.patch

	# it tries to create libdir, bindir etc on live system in configure
	ccp_patch "${FILESDIR}"/${PV}-dont-make-dirs-in-configure.patch

	# gerror_ gets defined twice on ppc if you're using gfortran/g95
	ccp_patch "${FILESDIR}"/6.0.2-ppc-double-define-gerror.patch

	# make creation of libccif.so smooth
	ccp_patch "${FILESDIR}"/${PV}-ccif-shared.patch

	# lets try to build libmmdb seperatly
	ccp_patch "${FILESDIR}"/${PV}-dont-build-mmdb.patch

	# unbundle libjpeg and cbflib
	ccp_patch "${FILESDIR}"/${PV}-unbundle-libs-ng2.patch

	# Fix missing DESTIDR
	# not installing during build
	ccp_patch "${FILESDIR}"/${PV}-noinstall.patch
	sed \
		-e '/SHARE_INST/s:$(libdir):$(DESTDIR)/$(libdir):g' \
		-i configure || die

	# Fix upstreams code
	ccp_patch "${FILESDIR}"/${PV}-impl-dec.patch

	# use pkg-config to detect BLAS/LAPACK
	ccp_patch "${FILESDIR}"/${PV}-lapack.patch

	# proto type changing in version 0.9.2.2
	ccp_patch "${FILESDIR}"/${PV}-cbf.patch

	# proto type changing in version 0.9.2.2
	ccp_patch "${FILESDIR}"/${PV}-no-pypath.patch

	ccp_patch "${FILESDIR}"/${P}-force.patch

	ccp_patch "${FILESDIR}"/${P}-format-security.patch

	einfo "Done." # done applying Gentoo patches
	echo

	# not needed, we have it extra
	rm -rf src/rapper/{libxml2,gc7.0} || die

	sed \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-e 's:-Wl,-rpath,$CLIB::g' \
		-e 's: -rpath $CLIB::g' \
		-e 's: -I${srcdir}/include/cpp_c_headers::g' \
		-e 's:sleep 1:sleep .2:g' \
		-i configure || die

	gnuconfig_update

	for i in lib/DiffractionImage src/rapper src/pisa; do
		pushd ${i} > /dev/null
			sed 's:-g::g' -i configure* || die
			[[ -f configure.in ]] && mv configure.{in,ac}
			eautoreconf
		popd > /dev/null
	done

	## unbundle libssm
	sed -e '/libdir/s:ssm::g' -i Makefile.in || die
	find ./lib/src/mmdb ./lib/ssm ./lib/clipper ./lib/fftw lib/lapack -delete || die
}

src_configure() {
	rm -rf lib/DiffractionImage/{jpg,CBFlib} || die

	# Build system is broken if we set LDFLAGS
	userldflags="${LDFLAGS}"
	export SHARED_LIB_FLAGS="${LDFLAGS}"
	unset LDFLAGS

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
		"${S}"/include/ccp4.setup || die

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

	export SHARE_LIB="\
		$(tc-getCC) ${userldflags} -shared -Wl,-soname,libccp4c.so -o libccp4c.so \${CORELIBOBJS} \${CGENERALOBJS} \${CUCOBJS} \${CMTZOBJS} \${CMAPOBJS} \${CSYMOBJS} -L../ccif/ -lccif $(gcc-config -L | awk -F: '{for(i=1; i<=NF; i++) printf " -L%s", $i}') -lm && \
		$(tc-getFC) ${userldflags} -shared -Wl,-soname,libccp4f.so -o libccp4f.so \${FORTRANLOBJS} \${FINTERFACEOBJS} -L../ccif/ -lccif -L. -lccp4c $($(tc-getPKG_CONFIG) --libs mmdb) $(gcc-config -L | awk -F: '{for(i=1; i<=NF; i++) printf " -L%s", $i}') -lstdc++ -lgfortran -lm"

	# Can't use econf, configure rejects unknown options like --prefix
	./configure \
		--onlylibs \
		--with-shared-libs \
		--with-fftw="${EPREFIX}/usr" \
		--with-warnings \
		--disable-cctbx \
		--disable-clipper \
		--disable-ssm \
		--tmpdir="${TMPDIR}" \
		--bindir="${EPREFIX}/usr/libexec/ccp4/bin/" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		${GENTOO_OSNAME} || die "configure failed"
}

src_compile() {
	emake DESTDIR="${D}" onlylib
}

src_install() {
	# Set up variables for build
	source "${S}"/include/ccp4.setup-sh

	emake \
		DESTDIR="${D}" \
		includedir="${EPREFIX}/usr/include" \
		library_includedir="${EPREFIX}/usr/include" \
		install

	sed \
		-e "330,1000d" \
		-i "${S}"/include/ccp4.setup-sh || die

	sed \
		-e "378,1000d" \
		-i "${S}"/include/ccp4.setup-csh || die

	sed \
		-e "s:-${PV/-r*/}::g" \
		-e "s:^\(.*export CCP4_MASTER=\).*:\1${EPREFIX}/usr:g" \
		-e "s:^\(.*setenv CCP4_MASTER\).*:\1 ${EPREFIX}/usr:g" \
		-e "s:^\(.*export CCP4=\).*CCP4_MASTER.*:\1${EPREFIX}/usr:g" \
		-e "s:^\(.*setenv CCP4\).*CCP4_MASTER.*:\1 ${EPREFIX}/usr:g" \
		-e "s:^\(.*export CCP4_SCR=\).*:\1${EPREFIX}/tmp:g" \
		-e "s:^\(.*setenv CCP4_SCR \).*:\1${EPREFIX}/tmp:g" \
		-e "s:^\(.*export BINSORT_SCR=\).*:\1${EPREFIX}/tmp:g" \
		-e "s:^\(.*setenv BINSORT_SCR \).*:\1${EPREFIX}/tmp:g" \
		-e "s:^\(.*export CCP4I_TOP=\).*:\1${EPREFIX}/usr/$(get_libdir)/ccp4/ccp4i:g" \
		-e "s:^\(.*setenv CCP4I_TOP \).*:\1${EPREFIX}/usr/$(get_libdir)/ccp4/ccp4i:g" \
		-e "s:^\(.*export CCP4I_TCLTK=\).*:\1${EPREFIX}/usr/bin:g" \
		-e "s:^\(.*setenv CCP4I_TCLTK \).*:\1${EPREFIX}/usr/bin:g" \
		-e "s:^\(.*export CCP4I_HELP=\).*:\1${EPREFIX}/usr/$(get_libdir)/ccp4/ccp4i/help:g" \
		-e "s:^\(.*setenv CCP4I_HELP \).*:\1${EPREFIX}/usr/$(get_libdir)/ccp4/ccp4i/help:g" \
		-e "s:^\(.*export CBIN=\).*:\1${EPREFIX}/usr/libexec/ccp4/bin:g" \
		-e "s:^\(.*setenv CBIN \).*:\1${EPREFIX}/usr/libexec/ccp4/bin:g" \
		-e "s:^\(.*export CCP4_BIN=\).*:\1${EPREFIX}/usr/libexec/ccp4/bin:g" \
		-e "s:^\(.*setenv CCP4_BIN \).*:\1${EPREFIX}/usr/libexec/ccp4/bin:g" \
		-e "s:^\(.*export CLIBD_MON=\).*:\1${EPREFIX}/usr/share/ccp4/data/monomers/:g" \
		-e "s:^\(.*setenv CLIBD_MON \).*:\1${EPREFIX}/usr/share/ccp4/data/monomers/:g" \
		-e "s:^\(.*export CLIBD=\).*:\1${EPREFIX}/usr/share/ccp4/data:g" \
		-e "s:^\(.*setenv CLIBD \).*:\1${EPREFIX}/usr/share/ccp4/data:g" \
		-e "s:^\(.*export CCP4_LIB=\).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:^\(.*setenv CCP4_LIB \).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:^\(.*export CCP4_BROWSER=\).*:\1firefox:g" \
		-e "s:^\(.*setenv CCP4_BROWSER \).*:\1firefox:g" \
		-e "s:^\(.*export MANPATH=\).*:\1\${MANPATH}:g" \
		-e "s:^\(.*setenv MANPATH \).*:\1\${MANPATH}:g" \
		-e "s:^\(.*export DBCCP4I_TOP=\).*:\1${EPREFIX}/usr/share/ccp4/dbccp4i:g" \
		-e "s:^\(.*setenv DBCCP4I_TOP \).*:\1${EPREFIX}/usr/share/ccp4/dbccp4i:g" \
		-e "s:^\(.*export MOLREPLIB=\).*:\1${EPREFIX}/usr/share/ccp4/data/monomers/:g" \
		-e "s:^\(.*setenv MOLREPLIB \).*:\1${EPREFIX}/usr/share/ccp4/data/monomers/:g" \
		-e "s:^\(.*export CDOC=\).*:\1${EPREFIX}/usr/share/doc:g" \
		-e "s:^\(.*setenv CDOC \).*:\1${EPREFIX}/usr/share/doc:g" \
		-e "s:^\(.*export CEXAM=\).*:\1${EPREFIX}/usr/share/doc/examples:g" \
		-e "s:^\(.*setenv CEXAM \).*:\1${EPREFIX}/usr/share/doc/examples:g" \
		-e "s:^\(.*export CINCL=\).*:\1${EPREFIX}/usr/share/ccp4/include:g" \
		-e "s:^\(.*setenv CINCL \).*:\1${EPREFIX}/usr/share/ccp4/include:g" \
		-e "s:\$CLIB/font84.dat:\"${EPREFIX}/usr/$(get_libdir)/font84.dat\":g" \
		-e "s:\$CLIB/cif_mmdic.lib:\"${EPREFIX}/usr/$(get_libdir)/cif_mmdic.lib\":g" \
		-e '/# .*LD_LIBRARY_PATH specifies/,/^$/d' \
		-e '/CLIB=/d' \
		-e '/CLIB /d' \
		-e '/CLIBS=/d' \
		-e '/CLIBS /d' \
		-e "/alias/d" \
		-e "/CCP4_HELPDIR/d" \
		-e "/IMOSFLM_VERSION/d" \
		-i "${S}"/include/ccp4.setup* || die

	# Don't check for updates on every sourcing of /etc/profile
	sed -i \
		-e "s:\(eval python.*\):#\1:g" \
		"${S}"/include/ccp4.setup* || die

	# Libs
	for file in "${S}"/lib/*; do
		if [[ -d ${file} ]]; then
			continue
		elif [[ -x ${file} ]]; then
			dolib.so ${file}
		else
			insinto /usr/$(get_libdir)
			doins ${file}
		fi
	done

	prune_libtool_files

	sed \
		-e 's:test "LD_LIBRARY_PATH":test "$LD_LIBRARY_PATH":g' \
		-i "${S}"/include/ccp4.setup-sh || die

	if ! use minimal; then
		# Setup scripts
		insinto /etc/profile.d
		newins "${S}"/include/ccp4.setup-csh 40ccp4.setup.csh
		newins "${S}"/include/ccp4.setup-sh 40ccp4.setup.sh

		# Data
		insinto /usr/share/ccp4/data/
		doins -r "${S}"/lib/data/{*.PARM,*.prt,*.lib,*.dic,*.idl,*.cif,*.resource,*.york,*.hist,fraglib,reference_structures}

		# Environment files, setup scripts, etc.
		rm -rf "${S}"/include/{ccp4.setup*,COPYING,cpp_c_headers} || die
		insinto /usr/share/ccp4/
		doins -r "${S}"/include
	fi

	rm -f "${S}"/include/ccp4.setup* || die

	dodoc "${S}"/lib/data/*.doc
	newdoc "${S}"/lib/data/README DATA-README
}

pkg_postinst() {
	einfo "The Web browser defaults to firefox. Change CCP4_BROWSER"
	einfo "in ${EPREFIX}/etc/profile.d/40ccp4.setup* to modify this."
}

# Epatch wrapper for bulk patching
ccp_patch() {
	EPATCH_SINGLE_MSG="  ${1##*/} ..." epatch ${1}
}
