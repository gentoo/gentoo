# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90"

inherit fortran-2 multilib-minimal

MY_PV=${PV/_/}
DESCRIPTION="A high performance and portable MPI implementation"
HOMEPAGE="http://www.mpich.org/"
SRC_URI="http://www.mpich.org/static/downloads/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="mpich"
KEYWORDS=""
IUSE="+cxx doc fortran mpi-threads romio threads"
REQUIRED_USE="mpi-threads? ( threads )"

COMMON_DEPEND="
	>=dev-libs/libaio-0.3.109-r5[${MULTILIB_USEDEP}]
	>=sys-apps/hwloc-1.10.0-r2[${MULTILIB_USEDEP}]
	romio? ( net-fs/nfs-utils )"

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	sys-devel/libtool"

RDEPEND="${COMMON_DEPEND}
	!sys-cluster/mpich2
	!sys-cluster/openmpi"

S="${WORKDIR}"/${PN}-${MY_PV}

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/mpicxx.h
	/usr/include/mpi.h
	/usr/include/opa_config.h
)

src_prepare() {
	default

	# Using MPICHLIB_LDFLAGS doesn't seem to fully work.
	sed -i 's| *@WRAPPER_LDFLAGS@ *||' \
		src/packaging/pkgconfig/mpich.pc.in \
		src/env/*.in \
		|| die
}

multilib_src_configure() {
	# The configure statements can be somewhat confusing, as they
	# don't all show up in the top level configure, however, they
	# are picked up in the children directories.

	export MPICHLIB_CFLAGS="${CFLAGS}"
	export MPICHLIB_CPPFLAGS="${CPPFLAGS}"
	export MPICHLIB_CXXFLAGS="${CXXFLAGS}"
	export MPICHLIB_FFLAGS="${FFLAGS}"
	export MPICHLIB_FCFLAGS="${FCFLAGS}"
	export MPICHLIB_LDFLAGS="${LDFLAGS}"
	unset CFLAGS CPPFLAGS CXXFLAGS FFLAGS FCFLAGS LDFLAGS

	ECONF_SOURCE=${S} econf \
		--enable-shared \
		--sysconfdir="${EPREFIX}/etc/${PN}" \
		--with-hwloc-prefix="${EPREFIX}/usr" \
		--enable-threads=$(usex mpi-threads runtime single) \
		--with-thread-package=$(usex threads pthreads none) \
		--with-pm=hydra \
		--disable-fast \
		--enable-versioning \
		$(use_enable romio) \
		$(use_enable cxx) \
		$(multilib_native_use_enable fortran fortran all)
}

multilib_src_test() {
	emake -j1 check
}

multilib_src_install() {
	default

	# fortran header cannot be wrapped (bug #540508), workaround part 1
	if multilib_is_native_abi && use fortran; then
		mkdir "${T}"/fortran || die
		mv "${ED}"usr/include/mpif* "${T}"/fortran || die
		mv "${ED}"usr/include/*.mod "${T}"/fortran || die
	else
		# some fortran files get installed unconditionally
		rm "${ED}"usr/include/mpif* "${ED}"usr/include/*.mod || die
	fi
}

multilib_src_install_all() {
	# fortran header cannot be wrapped (bug #540508), workaround part 2
	if use fortran; then
		mv "${T}"/fortran/* "${ED}"usr/include || die
	fi

	einstalldocs
	newdoc src/pm/hydra/README README.hydra
	if use romio; then
		newdoc src/mpi/romio/README README.romio
	fi

	if ! use doc; then
		rm -rf "${ED}"usr/share/doc/${PF}/www* || die
	fi
}
