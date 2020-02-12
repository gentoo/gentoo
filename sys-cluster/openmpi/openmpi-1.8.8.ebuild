# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

FORTRAN_NEEDED=fortran

inherit cuda eutils flag-o-matic fortran-2 java-pkg-opt-2 multilib toolchain-funcs versionator

MY_P=${P/-mpi}
S=${WORKDIR}/${MY_P}

IUSE_OPENMPI_FABRICS="
	openmpi_fabrics_ofed
	openmpi_fabrics_knem
	openmpi_fabrics_psm"

IUSE_OPENMPI_RM="
	openmpi_rm_pbs
	openmpi_rm_slurm"

IUSE_OPENMPI_OFED_FEATURES="
	openmpi_ofed_features_control-hdr-padding
	openmpi_ofed_features_connectx-xrc
	openmpi_ofed_features_udcm
	openmpi_ofed_features_rdmacm
	openmpi_ofed_features_dynamic-sl
	openmpi_ofed_features_failover"

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="http://www.open-mpi.org"
SRC_URI="http://www.open-mpi.org/software/ompi/v$(get_version_component_range 1-2)/downloads/${MY_P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux"
IUSE="cma cuda +cxx fortran heterogeneous ipv6 java mpi-threads numa romio threads vt
	${IUSE_OPENMPI_FABRICS} ${IUSE_OPENMPI_RM} ${IUSE_OPENMPI_OFED_FEATURES}"

REQUIRED_USE="openmpi_rm_slurm? ( !openmpi_rm_pbs )
	openmpi_rm_pbs? ( !openmpi_rm_slurm )
	openmpi_fabrics_psm? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_control-hdr-padding? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_connectx-xrc? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_udcm? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_rdmacm? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_dynamic-sl? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_failover? ( openmpi_fabrics_ofed )"

MPI_UNCLASSED_DEP_STR="
	vt? (
		!dev-libs/libotf
		!app-text/lcdf-typetools
	)"

CDEPEND="
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/pmix
	dev-libs/libevent
	dev-libs/libltdl:0
	<sys-apps/hwloc-2[numa?]
	sys-libs/zlib
	cuda? ( dev-util/nvidia-cuda-toolkit )
	openmpi_fabrics_ofed? ( sys-fabric/ofed:* )
	openmpi_fabrics_knem? ( sys-cluster/knem )
	openmpi_fabrics_psm? ( sys-fabric/infinipath-psm:* )
	openmpi_rm_pbs? ( sys-cluster/torque )
	openmpi_rm_slurm? ( sys-cluster/slurm )
	openmpi_ofed_features_rdmacm? ( sys-fabric/librdmacm:* )"

RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.6 )"

DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.6 )"

pkg_setup() {
	fortran-2_pkg_setup
	java-pkg-opt-2_pkg_setup

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
		--with-hwloc="${EPREFIX}/usr"
		--with-libltdl="${EPREFIX}/usr"
		)

	if use fortran; then
		myconf+=(--enable-mpi-fortran=all)
	else
		myconf+=(--enable-mpi-fortran=no)
	fi

	if use java; then
		# We must always build with the right -source and -target
		# flags. Passing flags to javac isn't explicitly supported here
		# but we can cheat by overriding the configure test for javac.
		export ac_cv_path_JAVAC="$(java-pkg_get-javac) $(java-pkg_javac-args)"
	fi

	! use vt && myconf+=(--enable-contrib-no-build=vt)

	econf "${myconf[@]}" \
		$(use_enable cxx mpi-cxx) \
		$(use_with cma) \
		$(use_with cuda cuda "${EPREFIX}"/opt/cuda) \
		$(use_enable romio io-romio) \
		$(use_enable heterogeneous) \
		$(use_enable ipv6) \
		$(use_enable mpi-threads mpi-thread-multiple) \
		$(use_with openmpi_fabrics_ofed verbs "${EPREFIX}"/usr) \
		$(use_with openmpi_fabrics_knem knem "${EPREFIX}"/usr) \
		$(use_with openmpi_fabrics_psm psm "${EPREFIX}"/usr) \
		$(use_enable openmpi_ofed_features_control-hdr-padding openib-control-hdr-padding) \
		$(use_enable openmpi_ofed_features_connectx-xrc openib-connectx-xrc) \
		$(use_enable openmpi_ofed_features_rdmacm openib-rdmacm) \
		$(use_enable openmpi_ofed_features_udcm openib-udcm) \
		$(use_enable openmpi_ofed_features_dynamic-sl openib-dynamic-sl) \
		$(use_enable openmpi_ofed_features_failover btl-openib-failover) \
		$(use_with openmpi_rm_pbs tm) \
		$(use_with openmpi_rm_slurm slurm) \
		$(use_enable java) \
		$(use_enable java mpi-java)
}

src_install () {
	emake DESTDIR="${D}" install

	# From USE=vt see #359917
	rm "${ED}"/usr/share/libtool &> /dev/null

	# Avoid collisions with libevent
	rm -rf "${ED}"/usr/include/event2 &> /dev/null

	# Remove la files, no static libs are installed and we have pkg-config
	find "${ED}"/usr/$(get_libdir)/ -type f -name '*.la' -delete

	if use java; then
		local mpi_jar="${ED}"/usr/$(get_libdir)/mpi.jar
		java-pkg_dojar "${mpi_jar}"
		# We don't want to install the jar file twice
		# so let's clean after ourselves.
		rm "${mpi_jar}" || die
	fi

	dodoc README AUTHORS NEWS VERSION
}

src_test() {
	# Doesn't work with the default src_test as the dry run (-n) fails.
	emake -j1 check
}
