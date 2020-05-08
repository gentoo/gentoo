# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=fortran

inherit fortran-2 flag-o-matic toolchain-funcs

MY_P=${P/-mpi}

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="https://www.open-mpi.org"
SRC_URI="https://www.open-mpi.org/software/ompi/v1.4/downloads/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
RESTRICT="mpi-threads? ( test )"

KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE="+cxx fortran heterogeneous ipv6 mpi-threads pbs romio threads vt"
RDEPEND="
	pbs? ( sys-cluster/torque )
	vt? (
		!dev-libs/libotf
		!app-text/lcdf-typetools
	)
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/pmix"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	fortran-2_pkg_setup
	if use mpi-threads; then
		echo
		ewarn "WARNING: use of MPI_THREAD_MULTIPLE is still disabled by"
		ewarn "default and officially unsupported by upstream."
		ewarn "You may stop now and set USE=-mpi-threads"
		echo
	fi

	echo
	elog "OpenMPI has an overwhelming count of configuration options."
	elog "Don't forget the EXTRA_ECONF environment variable can let you"
	elog "specify configure options if you find them necessary."
	echo
}

src_prepare() {
	default
	# Necessary for scalibility, see
	# http://www.open-mpi.org/community/lists/users/2008/09/6514.php
	if use threads; then
		echo 'oob_tcp_listen_mode = listen_thread' \
			>> opal/etc/openmpi-mca-params.conf
	fi
}

src_configure() {
	local myconf=(
		--sysconfdir="${EPREFIX}/etc/${PN}"
		--enable-pretty-print-stacktrace
		--enable-orterun-prefix-by-default
		--without-slurm)

	if use mpi-threads; then
		myconf+=(--enable-mpi-threads
			--enable-progress-threads)
	fi

	if use fortran; then
		if [[ $(tc-getFC) =~ g77 ]]; then
			myconf+=(--disable-mpi-f90)
		elif [[ $(tc-getFC) =~ if ]]; then
			# Enabled here as gfortran compile times are huge with this enabled.
			myconf+=(--with-mpi-f90-size=medium)
		fi
	else
		myconf+=(--disable-mpi-f90 --disable-mpi-f77)
	fi

	! use vt && myconf+=(--enable-contrib-no-build=vt)

	econf "${myconf[@]}" \
		$(use_enable cxx mpi-cxx) \
		$(use_enable romio io-romio) \
		$(use_enable heterogeneous) \
		$(use_with pbs tm) \
		$(use_enable ipv6)
}

src_install() {
	default
	dodoc README AUTHORS NEWS VERSION
}

src_test() {
	# Doesn't work with the default src_test as the dry run (-n) fails.
	emake -j1 check
}
