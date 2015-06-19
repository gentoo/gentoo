# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gamess/gamess-20110811.1.ebuild,v 1.4 2013/02/27 16:50:41 jlec Exp $

EAPI=4

inherit eutils fortran-2 flag-o-matic pax-utils toolchain-funcs

DESCRIPTION="A powerful quantum chemistry package"
LICENSE="gamess"
HOMEPAGE="http://www.msg.chem.iastate.edu/GAMESS/GAMESS.html"
SRC_URI="
		${P}.tar.gz
		qmmm-tinker? ( tinker.tar.Z )"

SLOT="0"
# NOTE: PLEASE do not stabilize gamess. It does not make sense
# since the tarball has fetch restrictions and upstream only
# provides the latest version. In other words: As soon as a
# new version comes out the stable version will be useless since
# users can not get at the tarball any more.
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mpi neo pax_kernel qmmm-tinker"

CDEPEND="
	app-shells/tcsh
	mpi? ( virtual/mpi )
	virtual/blas"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	net-misc/openssh"

S="${WORKDIR}/${PN}"

RESTRICT="fetch"

GAMESS_DOWNLOAD="http://www.msg.ameslab.gov/GAMESS/License_Agreement.html"
GAMESS_VERSION="1 AUG 2011 (R1)"

pkg_nofetch() {
	echo
	elog "Please download ${PN}-current.tar.gz from"
	elog "${GAMESS_DOWNLOAD}."
	elog "Be sure to select the version ${GAMESS_VERSION} tarball!!"
	elog "Then move the tarball to"
	elog "${DISTDIR}/${P}.tar.gz"
	if use qmmm-tinker ; then
		elog "Also download http://www.msg.ameslab.gov/GAMESS/tinker.tar.Z"
		elog "and place tinker.tar.Z to ${DISTDIR}"
	fi
	echo
}

get_fcomp() {
	case $(tc-getFC) in
		*gfortran* )
			FCOMP="gfortran" ;;
		ifort )
			FCOMP="ifc" ;;
		* )
			FCOMP=$(tc-getFC) ;;
	esac
}

pkg_setup() {
	fortran-2_pkg_setup
	get_fcomp
	# currently amd64 is only supported with gfortran
	if [[ "${ARCH}" == "amd64" ]] && [[ ${FCOMP} != *gfortran* ]];
		then die "You will need gfortran to compile gamess on amd64"
	fi

	# note about qmmm-tinker
	if use qmmm-tinker; then
			einfo "By default MM subsistem is restricted to 1000 atoms"
			einfo "if you want larger MM subsystems then you should set"
			einfo "QMMM_GAMESS_MAXMM variable to needed value in your make.conf"
			einfo "By default maximum number of atom classes types and size of"
			einfo "hessian are restricted to 250, 500 and 1000000 respectively"
			einfo "If you want larger sizes set:"
			einfo "QMMM_GAMESS_MAXCLASS"
			einfo "QMMM_GAMESS_MAXCTYP"
			einfo "QMMM_GAMESS_MAXHESS"
			einfo "in your make.conf"
	fi

	#note about mpi
	if use mpi; then
		ewarn ""
		ewarn "You should adjust rungms script for your mpi implentation"
		ewarn "because deafult one will not work"
		ewarn ""
	fi
}

src_unpack() {
	unpack ${A}

	if use qmmm-tinker; then
		mv tinker gamess/ || die "failed to move tinker directory"
	fi
}

src_prepare() {
	tc-export PKG_CONFIG
	# apply LINUX-arch patches to gamess makesfiles
	epatch "${FILESDIR}/${P}.gentoo.patch"
	epatch "${FILESDIR}/${PN}-checktst.patch"
	# select arch
	# NOTE: please leave lked alone; it should be good as is!!
	cd "${S}"
	local active_arch;
	if [[ "${ARCH}" == "amd64" ]]; then
		active_arch="linux64";
	else
		active_arch="linux32";
	fi

	# for hardened-gcc let't turn off ssp, since it breakes
	# a few routines
	if use pax_kernel && [[ ${FCOMP} == g77 ]]; then
		FFLAGS="${FFLAGS} -fno-stack-protector-all"
	fi

	# Enable mpi stuff
	if use mpi; then
		sed -e "s:set COMM = sockets:set COMM = mpi:g" \
			-i ddi/compddi || die "Enabling mpi build failed"
		sed -e "s:MPI_INCLUDE_PATH = ' ':MPI_INCLUDE_PATH =	'-I/usr/include ':g" \
			-i ddi/compddi || die "Enabling mpi build failed"
		sed -e "s:MSG_LIBRARIES='../ddi/libddi.a -lpthread':MSG_LIBRARIES='../ddi/libddi.a -lmpi -lpthread':g" \
			-i lked || die "Enabling mpi build failed"
	fi

	# enable NEO
	if use neo; then
		sed -e "s:NEO=false:NEO=true:" -i compall lked || \
			die "Failed to enable NEO code"
	else
		sed -e "s:NEO=true:NEO=false:" -i compall lked || \
			die "Failed to disable NEO code"
	fi
	# enable GAMESS-qmmm
	if use qmmm-tinker; then
		epatch "${FILESDIR}/${PN}-qmmm-tinker-fix-idate.patch"
		sed -e "s:TINKER=false:TINKER=true:" -i compall lked || \
			die "Failed to enable TINKER code"
		if [ "x$QMMM_GAMESS_MAXMM" == "x" ]; then
			einfo "No QMMM_GAMESS_MAXMM set. Using default value = 1000"
		else
			einfo "Setting QMMM_GAMESS_MAXMM to $QMMM_GAMESS_MAXMM"
			sed -e "s:maxatm=1000:maxatm=$QMMM_GAMESS_MAXMM:g" \
			 -i tinker/sizes.i \
			 || die "Setting QMMM_GAMESS_MAXMM failed"
			sed -e "s:MAXATM=1000:MAXATM=$QMMM_GAMESS_MAXMM:g" \
			 -i source/inputb.src \
			 || die "Setting QMMM_GAMESS_MAXMM failed"
		fi
		if [ "x$QMMM_GAMESS_MAXCLASS" == "x" ]; then
			einfo "No QMMM_GAMESS_MAXMM set. Using default value = 250"
		else
			sed -e "s:maxclass=250:maxclass=$QMMM_GAMESS_MAXCLASS:g" \
				-i tinker/sizes.i \
				|| die "Setting QMMM_GAMESS_MAXCLASS failed"
		fi
		if [ "x$QMMM_GAMESS_MAXCTYP" == "x" ]; then
			einfo "No QMMM_GAMESS_MAXCTYP set. Using default value = 500"
		else
			sed -e "s:maxtyp=500:maxtyp=$QMMM_GAMESS_MAXCTYP:g" \
				-i tinker/sizes.i \
				|| die "Setting QMMM_GAMESS_MAXCTYP failed"
		fi
		if [ "x$QMMM_GAMESS_MAXHESS" == "x" ]; then
			einfo "No QMMM_GAMESS_MAXHESS set. Usingdefault value = 1000000"
		else
			sed -e "s:maxhess=1000000:maxhess=$QMMM_GAMESS_MAXHESS:g" \
				-i tinker/sizes.i \
				|| die "Setting QMMM_GAMESS_MAXHESS failed"
		fi
	fi
	# greate proper activate sourcefile
	cp "./tools/actvte.code" "./tools/actvte.f" || \
		die "Failed to create actvte.f"
	sed -e "s/^\*UNX/    /" -i "./tools/actvte.f" || \
		die "Failed to perform UNX substitutions in actvte.f"

	# fix GAMESS' compall script to use proper CC
	sed -e "s|\$CCOMP -c \$extraflags source/zunix.c|$(tc-getCC) -c \$extraflags source/zunix.c|" \
		-i compall || die "Failed setting up compall script"

	# insert proper FFLAGS into GAMESS' comp makefile
	# in case we're using ifc let's strip all the gcc
	# specific stuff
	if [[ ${FCOMP} == "ifort" ]]; then
		sed -e "s/gentoo-OPT = '-O2'/OPT = '${FFLAGS} -quiet'/" \
			-i comp || die "Failed setting up comp script"
	elif ! use x86; then
		sed -e "s/-malign-double //" \
			-e "s/gentoo-OPT = '-O2'/OPT = '${FFLAGS}'/" \
			-i comp || die "Failed setting up comp script"
	else
		sed -e "s/gentoo-OPT = '-O2'/OPT = '${FFLAGS}'/" \
			-i comp || die "Failed setting up comp script"
	fi

	# fix up GAMESS' linker script;
	sed -e "s/gentoo-LDOPTS=' '/LDOPTS='${LDFLAGS}'/" \
		-i lked || die "Failed setting up lked script"
	# fix up GAMESS' ddi TCP/IP socket build
	sed -e "s/gentoo-CC = 'gcc'/CC = '$(tc-getCC)'/" \
		-i ddi/compddi || die "Failed setting up compddi script"
	# Creating install.info
	cat > install.info <<-EOF
	#!/bin/csh
	setenv GMS_PATH $WORKDIR/gamess
	setenv GMS_TARGET $active_arch
	setenv GMS_FORTRAN $FCOMP
	setenv GMS_MATHLIB atlas
	setenv GMS_MATHLIB_PATH  /usr/$(get_libdir)/atlas
	setenv GMS_DDI_COMM sockets
	EOF

}

src_compile() {
	# build actvte
	cd "${S}"/tools
	${FCOMP} -o actvte.x actvte.f || \
		die "Failed to compile actvte.x"

	# for hardened (PAX) users and ifc we need to turn
	# MPROTECT off
	if [[ ${FCOMP} == "ifort" ]] && use pax_kernel; then
		pax-mark -PemRxS actvte.x
	fi

	# build gamess
	cd "${S}"
	./compall || die "compall failed"

	# build the ddi TCP/IP socket stuff
	cd ${S}/"ddi"
	./compddi || die "compddi failed"

	# finally, link it all together
	cd "${S}"
	./lked || die "lked failed"

	# for hardened (PAX) users and ifc we need to turn
	# MPROTECT off
	if [[ ${FCOMP} == "ifort" ]] && use pax_kernel; then
		pax-mark -PemRxS ${PN}.00.x
	fi
}

src_install() {
	# the executables
	dobin ${PN}.00.x rungms \
		|| die "Failed installing binaries"
	if use !mpi; then
		dobin ddi/ddikick.x \
			|| die "Failed installing binaries"
	fi

	# the docs
	dodoc *.DOC qmnuc/*.DOC || die "Failed installing docs"

	# install ericftm
	insinto /usr/share/${PN}
	doins auxdata/ericfmt.dat || die "Failed installing ericfmt.dat"

	# install mcpdata
	insinto /usr/share/${PN}/MCP
	doins auxdata/MCP/* || die "Failed installing MCP"

	# install BASES
	insinto /usr/share/${PN}/BASES
	doins auxdata/BASES/* || die "Failed installing BASES"

	# install QUANPOL
	insinto /usr/share/${PN}/QUANPOL
	doins auxdata/QUANPOL/* || die "Failed installing QUANPOL"

	# install tinker params in case of qmmm
	if use qmmm-tinker ; then
			dodoc tinker/simomm.doc || die "Failed installing docs"
			insinto /usr/share/${PN}
			doins -r tinker/params51 || die "Failed to install Tinker params"
	fi

	# install the tests the user should run, and
	# fix up the runscript; also grab a copy of rungms
	# so the user is ready to run the tests
	insinto /usr/share/${PN}/tests
	insopts -m0644
	doins tests/* || die "Failed installing tests"
	insopts -m0744
	doins runall || die "Failed installing tests"
	doins tools/checktst/checktst tools/checktst/chkabs || \
		die "Failed to install main test checker"
	doins tools/checktst/exam* || \
		die "Failed to install individual test files"

	insinto /usr/share/${PN}/neotests
	insopts -m0644
	doins -r qmnuc/neotests/* || die "Failed to install NEO tests"
}

pkg_postinst() {
	echo
	einfo "Before you use GAMESS for any serious work you HAVE"
	einfo "to run the supplied test files located in"
	einfo "/usr/share/gamess/tests and check them thoroughly."
	einfo "Otherwise all scientific publications resulting from"
	einfo "your GAMESS runs should be immediately rejected :)"
	einfo "To do so copy the content of /usr/share/gamess/tests"
	einfo "to some temporary location and execute './runall'. "
	einfo "Then run the checktst script in the same directory to"
	einfo "validate the tests."
	einfo "Please consult TEST.DOC and the other docs!"

	if [[ ${FCOMP} == "ifort" ]]; then
		echo
		ewarn "IMPORTANT NOTE: We STRONGLY recommend to stay away"
		ewarn "from ifc-9.0 for now and use the ifc-8.1 series of"
		ewarn "compilers UNLESS you can run through ALL of the "
		ewarn "test cases (see above) successfully."
	fi

	echo
	einfo "If you want to run on more than a single CPU"
	einfo "you will have to acquaint yourself with the way GAMESS"
	einfo "does multiprocessor runs and adjust rungms according to"
	einfo "your target network architecture."
	echo
}
