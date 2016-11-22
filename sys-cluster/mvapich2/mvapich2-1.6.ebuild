# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit fortran-2

DESCRIPTION="MVAPICH2 MPI-over-infiniband package auto-configured for OpenIB"
HOMEPAGE="http://mvapich.cse.ohio-state.edu/"
SRC_URI="${HOMEPAGE}/download/mvapich2/mvapich2-${PV/_/-}.tgz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86 ~amd64"
IUSE="debug fortran large-cluster medium-cluster romio threads"

RDEPEND="
	|| (
		(
			sys-fabric/libibverbs
			sys-fabric/libibumad
			sys-fabric/libibmad
			sys-fabric/librdmacm )
		sys-fabric/openib-userspace )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/mvapich2-${PV/_/-}"

pkg_setup() {
	fortran-2_pkg_setup

	if [ -z "${MVAPICH_HCA_TYPE}" ]; then
		elog "${PN} needs to know which HCA it should optimize for.  This is"
		elog "passed to the ebuild with the variable, \${MVAPICH_HCA_TYPE}."
		elog "Please choose one of:  _MLX_PCI_EX_SDR_, _MLX_PCI_EX_DDR_,"
		elog "_MLX_PCI_X, _PATH_HT_, or _IBM_EHCA_."
		elog "See make.mvapich2.detect in ${S} for more information."
		die "MVAPICH_HCA_TYPE undefined"
	fi

	case ${ARCH} in
		amd64)
			if grep Intel /proc/cpuinfo &>/dev/null; then
				BUILD_ARCH=-D_EM64T_
			else
				BUILD_ARCH=-D_X86_64_
			fi
			;;
		x86)
			BUILD_ARCH=-D_IA32_
			;;
		ia64)
			BUILD_ARCH=-D_IA64_
			;;
		ppc64)
			BUILD_ARCH=-D_PPC64_
			;;
		*)
			die "unsupported architecture: ${ARCH}"
			;;
	esac
}

src_prepare() {
	einfo "Disabling examples"
	# Examples are always compiled with the default 'all' target.  This
	# causes problems when we don't build support for everything, including
	# threads, mpe2, etc.  So we're not going to build them.
	sed -i 's:.*cd examples && ${MAKE} all.*::' Makefile.in
}

src_configure() {
	local c="--with-device=osu_ch3:mrail
		--with-rdma=gen2
		--with-pm=mpd
		$(use_enable romio)
		--with-mpe=no"

	# TODO Shared libs should build with this, but they don't
	# --enable-shared=gcc"

	local enable_srq
	local vcluster=-D_SMALL_CLUSTER

	use large-cluster 	&& vcluster=-D_LARGE_CLUSTER
	use medium-cluster 	&& vcluster=-D_MEDIUM_CLUSTER
	[ "${MVAPICH_HCA_TYPE}" == "_MLX_PCI_X_" ] && enable_srq="-DSRQ"

	append-ldflags "-lrdmacm"
	append-flags "-DADAPTIVE_RDMA_FAST_PATH -DRDMA_CM"

	append-ldflags "-libverbs -libumad -libmad"

	append-flags "${BUILD_ARCH} -DUSE_INLINE -D_SMP_ -D_GNU_SOURCE"
	append-flags "${enable_srq} -DUSE_HEADER_CACHING -DLAZY_MEM_UNREGISTER"
	append-flags "-DONE_SIDED -D${MVAPICH_HCA_TYPE} ${vcluster}"
	append-flags "-DMPID_USE_SEQUENCE_NUMBERS -DUSE_MPD_RING"

	use debug && c="${c} --enable-g=all --enable-debuginfo"

	if use threads; then
		c="${c} --enable-threads=multiple --with-thread-package=pthreads"
		append-flags "-pthread"
	else
		c="${c} --with-thread-package=none"
	fi

	# enable f90 support for appropriate compilers
	if use fortran; then
		case "$(tc-getFC)" in
			gfortran|ifort|f95)
				c="${c} --enable-f77 --enable-f90";;
			g77|f77|f2c)
				c="${c} --enable-f77 --disable-f90";;
		esac
	else
		c="${c} --disable-f77 --disable-f90"
	fi

	sed -i \
		-e 's/ ${exec_prefix}/ ${DESTDIR}${exec_prefix}/' \
		-e 's/ ${libdir}/ ${DESTDIR}${libdir}/' \
		${S/-beta2/}/Makefile.in
	sed -i '/bindir/s/ ${bindir}/ ${DESTDIR}${bindir}/' ${S/-beta2/}/src/pm/mpd/Makefile.in
	cd ${S/-beta2/}

	econf ${c}
}

src_install() {
	emake  DESTDIR="${D}"|| die
	dodoc CHANGES_MPICH2 COPYRIGHT COPYRIGHT_MVAPICH2 LICENSE.TXT \
		README* RELEASE_NOTES*
}

pkg_postinst() {
	einfo "To allow normal users to use infiniband, it is necessary to"
	einfo "increase the system limits on locked memory."
	einfo "You must increase the kernel.shmmax sysctl value, and increase"
	einfo "the memlock limits in /etc/security/limits.conf.  i.e.:"
	echo
	einfo "echo 'kernel.shmmax = 512000000' >> /etc/sysctl.conf"
	einfo "echo 512000000 > /proc/sys/kernel/shmmax"
	einfo "echo -e '* soft memlock 500000\n* hard memlock 500000' > /etc/security/limits.conf"
}
