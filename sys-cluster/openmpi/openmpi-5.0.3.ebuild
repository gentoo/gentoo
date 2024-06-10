# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran
inherit cuda flag-o-matic fortran-2 libtool

MY_P=${P/-mpi}

IUSE_OPENMPI_FABRICS="
	openmpi_fabrics_ofed
	openmpi_fabrics_knem"

IUSE_OPENMPI_RM="
	openmpi_rm_pbs
	openmpi_rm_slurm"

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="https://www.open-mpi.org"
SRC_URI="https://www.open-mpi.org/software/ompi/v$(ver_cut 1-2)/downloads/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 -arm -ppc -x86 ~amd64-linux"
IUSE="cma cuda cxx fortran ipv6 peruse romio valgrind
	${IUSE_OPENMPI_FABRICS} ${IUSE_OPENMPI_RM}"

REQUIRED_USE="
	openmpi_rm_slurm? ( !openmpi_rm_pbs )
	openmpi_rm_pbs? ( !openmpi_rm_slurm )
"

RDEPEND="
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/nullmpi
	>=dev-libs/libevent-2.0.22:=[threads(+)]
	>=sys-apps/hwloc-2.0.2:=
	sys-cluster/pmix:=
	>=sys-libs/zlib-1.2.8-r1
	cuda? ( >=dev-util/nvidia-cuda-toolkit-6.5.19-r1:= )
	openmpi_fabrics_ofed? ( sys-cluster/rdma-core )
	openmpi_fabrics_knem? ( sys-cluster/knem )
	openmpi_rm_pbs? ( sys-cluster/torque )
	openmpi_rm_slurm? ( sys-cluster/slurm )
"
DEPEND="${RDEPEND}
	valgrind? ( dev-debug/valgrind )"

pkg_setup() {
	fortran-2_pkg_setup

	elog
	elog "OpenMPI has an overwhelming count of configuration options."
	elog "Don't forget the EXTRA_ECONF environment variable can let you"
	elog "specify configure options if you find them necessary."
	elog
}

src_prepare() {
	default
	elibtoolize

	# Avoid test which ends up looking at system mounts
	echo "int main() { return 0; }" > test/util/opal_path_nfs.c || die

	# Necessary for scalibility, see
	# http://www.open-mpi.org/community/lists/users/2008/09/6514.php
	echo 'oob_tcp_listen_mode = listen_thread' \
		>> opal/etc/openmpi-mca-params.conf || die
}

src_configure() {
	# -Werror=lto-type-mismatch, -Werror=strict-aliasing
	# The former even prevents successfully running ./configure, but both appear
	# at `make` time as well.
	# https://bugs.gentoo.org/913040
	# https://github.com/open-mpi/ompi/issues/12674
	# https://github.com/open-mpi/ompi/issues/12675
	append-flags -fno-strict-aliasing
	filter-lto

	local myconf=(
		--disable-mpi-java
		# configure takes a looooong time, but upstream currently force
		# constriants on caching:
		# https://github.com/open-mpi/ompi/blob/9eec56222a5c98d13790c9ee74877f1562ac27e8/config/opal_config_subdir.m4#L118
		# so no --cache-dir for now.
		--enable-mpi-fortran=$(usex fortran all no)
		--enable-orterun-prefix-by-default
		--enable-pretty-print-stacktrace

		--sysconfdir="${EPREFIX}/etc/${PN}"

		--with-hwloc=external
		--with-libevent=external

		# Oiriginally supposed to be re-enabled for 5.0!
		# See https://github.com/open-mpi/ompi/issues/9697#issuecomment-1003746357
		# and https://bugs.gentoo.org/828123#c14
		#
		# However as of 5.0.3 the docs still say:
		#
		#   As such, supporting data heterogeneity is a feature that has fallen
		#   into disrepair and is currently known to be broken in this release
		#   of Open MPI.
		--disable-heterogeneous

		$(use_enable cxx mpi-cxx)
		$(use_enable ipv6)
		$(use_enable peruse)
		$(use_enable romio io-romio)

		$(use_with cma)

		$(use_with cuda cuda "${EPREFIX}"/opt/cuda)
		$(use_with valgrind)
		$(use_with openmpi_fabrics_knem knem "${EPREFIX}"/usr)
		$(use_with openmpi_rm_pbs tm)
		$(use_with openmpi_rm_slurm slurm)
	)

	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myconf[@]}"
}

src_compile() {
	emake V=1
}

src_test() {
	emake -C test check
}

src_install() {
	default

	# Remove la files, no static libs are installed and we have pkg-config
	find "${ED}" -name '*.la' -delete || die
}
