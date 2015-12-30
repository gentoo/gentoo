# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=fortran

inherit eutils fortran-2 java-pkg-opt-2 toolchain-funcs

MY_P=${P/_/}

DESCRIPTION="MPI development tools"
HOMEPAGE="http://www-unix.mcs.anl.gov/perfvis/download/index.htm"
SRC_URI="ftp://ftp.mcs.anl.gov/pub/mpi/${PN%2}/${MY_P}.tar.gz"

LICENSE="mpich2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug minimal fortran threads"

COMMON_DEPEND="
	!minimal? (
		x11-libs/libXtst
		x11-libs/libXi
	)
	|| (
		sys-cluster/openmpi[fortran?,threads?]
		sys-cluster/mpich2[fortran?,threads?]
	)"

DEPEND="
	!minimal? ( >=virtual/jdk-1.6 )
	${COMMON_DEPEND}"

RDEPEND="
	!minimal? ( >=virtual/jre-1.6 )
	${COMMON_DEPEND}"

S="${WORKDIR}"/${MY_P}
MPE_IMP=""

# README:
# This ebuild is created to handle building with both mpich2 and openmpi.
# However, without empi (in the science overlay), and some further
# conversion to use mpi.eclass, we can only handle one implementation
# at a time.  I still believe it's better to have the ebuild setup
# correctly in preperation.

pkg_setup() {
	fortran-2_pkg_setup
	local i

	if has_version sys-cluster/openmpi; then
		MPE_IMP=openmpi
	elif has_version sys-cluster/mpich2; then
		MPE_IMP=mpich2
	elif has_version sys-cluster/mpich; then
		MPE_IMP=mpich2
	else
		die "Unknown MPI implementation"
	fi

	export JFLAGS="${JFLAGS} $(java-pkg_javac-args)"

	if [[ "${MPE_IMP}" == openmpi ]] && [ -z "${MPE2_FORCE_OPENMPI_TEST}" ]; then
		echo
		elog "Currently src_test fails on collchk with openmpi, hence"
		elog "testing is disabled by default.  If you would like to"
		elog "force testing, please add MPE_FORCE_OPENMPI_TEST=1"
		elog "to your environment."
		echo
	fi

	einfo "Building with support for: sys-cluster/${MPE_IMP}"

	use minimal || java-pkg-opt-2_pkg_setup
}

src_prepare() {
	# Don't assume path contains ./
	sed -i 's,\($MPERUN\) $pgm,\1 ./$pgm,' sbin/mpetestexeclog.in || die
	epatch \
		"${FILESDIR}"/slog2sdk-trace_rlog-makefile-fixes.patch \
		"${FILESDIR}"/slog2sdk-trace_sample-makefile-fixes.patch

	use minimal || java-pkg-opt-2_src_prepare
}

src_configure() {
	local c="--with-mpicc=/usr/bin/mpicc"

	if use fortran; then
		c+=" --with-mpif77=/usr/bin/mpif77"
	else
		c+=" --disable-f77"
	fi

	if use minimal; then
		c+=" --enable-slog2=no --disable-rlog --disable-sample"
	else
		c+=" --with-java2=$(java-config --jdk-home) --enable-slog2=build"
	fi

	[[ "${MPE_IMP}" == openmpi ]] && c+=" --disable-rlog --disable-sample"

	econf ${c} \
		--sysconfdir=/etc/${PN} \
		--datadir=/usr/share/${PN} \
		--with-htmldir=/usr/share/${PN} \
		--with-docdir=/usr/share/${PN} \
		--enable-collchk \
		--enable-wrappers \
		$(use_enable !minimal graphics) \
		$(use_enable threads threadlogging) \
		$(use_enable debug g)
}

src_test() {
	local rc

	cd "${S}" || die
	if [[ "${MPE_IMP}" == mpich2 ]]; then
		echo "MPD_SECRETWORD=junk" > "${T}"/mpd.conf || die
		chmod 600 "${T}"/mpd.conf || die
		export MPD_CONF_FILE="${T}/mpd.conf"
		"${ROOT}"usr/bin/mpd -d --pidfile="${T}"/mpd.pid || die
	elif [[ "${MPE_IMP}" == openmpi* ]] && [ -z "${MPE2_FORCE_OPENMPI_TEST}" ]; then
		echo
		einfo "Skipping tests for openmpi"
		echo
		return 0
	fi

	# No parallel make:
	# http://trac.mcs.anl.gov/projects/mpich2/ticket/1095#comment:1
	emake -j1 \
		CC="${S}"/bin/mpecc \
		FC="${S}"/bin/mpefc \
		MPERUN="${ROOT}/usr/bin/mpiexec -n 4" \
		CLOG2TOSLOG2="${S}/src/slog2sdk/bin/clog2TOslog2" \
		check;
		rc=${?}
	if [[ "${MPE_IMP}" == mpich2 ]]; then
		"${ROOT}"usr/bin/mpdallexit || kill $(<"${T}"/mpd.pid)
	fi

	return ${rc}
}

src_install() {
	# No parallel make:
	# http://trac.mcs.anl.gov/projects/mpich2/ticket/1095#comment:1
	MAKEOPTS+=" -j1"
	default
	rm -f "${ED}"/usr/sbin/mpeuninstall || die
}
