# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

OFED_VER="4.17-1"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="1.1.ge153426"

IUSE_OFED_DRIVERS="
		ofed_drivers_cxgb3
		ofed_drivers_cxgb4
		ofed_drivers_ehca
		ofed_drivers_ipath
		ofed_drivers_mlx4
		ofed_drivers_mlx5
		ofed_drivers_mthca
		ofed_drivers_nes
		ofed_drivers_ocrdma
		ofed_drivers_psm"

inherit openib udev toolchain-funcs

DESCRIPTION="OFED system files"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="dapl +diags ibacm +opensm perftest qperf rds srp ${IUSE_OFED_DRIVERS}"

RDEPEND="sys-fabric/rdma-core:=
		dapl? ( sys-fabric/dapl:${SLOT} )
		diags? ( sys-fabric/infiniband-diags:${SLOT} )
		opensm? ( sys-fabric/opensm:${SLOT} )
		perftest? ( sys-fabric/perftest:${SLOT} )
		qperf? ( sys-fabric/qperf:${SLOT} )
		rds? ( sys-fabric/rds-tools:${SLOT} )"
DEPEND="${RDEPEND}
		virtual/pkgconfig"
block_other_ofed_versions

SCRIPTDIR="${S}/ofed_scripts"

src_configure() { :; }
src_compile() { :; }

src_install() {
	udev_newrules "${SCRIPTDIR}/90-ib.rules" 40-ib.rules
	insinto /etc/modprobe.d
	newins "${FILESDIR}/openib.modprobe" openib.conf
	newenvd "${FILESDIR}/openib.env" 02openib
	insinto /etc/infiniband

	doinitd "${FILESDIR}/openib"

	# build openib.conf based on ofed_scripts/ofa_kernel.spec
	build_ipoib=1
	cp "${SCRIPTDIR}/openib.conf" "${T}"
	IB_CONF_DIR=${T}
	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Load UCM module" >> ${IB_CONF_DIR}/openib.conf
	echo "UCM_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Load RDMA_CM module" >> ${IB_CONF_DIR}/openib.conf
	echo "RDMA_CM_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Load RDMA_UCM module" >> ${IB_CONF_DIR}/openib.conf
	echo "RDMA_UCM_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Increase ib_mad thread priority" >> ${IB_CONF_DIR}/openib.conf
	echo "RENICE_IB_MAD=no" >> ${IB_CONF_DIR}/openib.conf

	echo >> ${IB_CONF_DIR}/openib.conf
	echo "# Load MTHCA" >> ${IB_CONF_DIR}/openib.conf
	echo "MTHCA_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	if use ofed_drivers_ipath; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load IPATH" >> ${IB_CONF_DIR}/openib.conf
		echo "IPATH_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use ofed_drivers_ehca; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load eHCA" >> ${IB_CONF_DIR}/openib.conf
		echo "EHCA_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use ofed_drivers_mlx4; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load MLX4 modules" >> ${IB_CONF_DIR}/openib.conf
		echo "MLX4_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	fi
	if (( build_ipoib )); then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load IPoIB" >> ${IB_CONF_DIR}/openib.conf
		echo "#IPOIB_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Enable IPoIB Connected Mode" >> ${IB_CONF_DIR}/openib.conf
		echo "#SET_IPOIB_CM=yes" >> ${IB_CONF_DIR}/openib.conf
		# from ofa_user.spec:
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Enable IPoIB High Availability daemon" >> ${IB_CONF_DIR}/openib.conf
		echo "#IPOIBHA_ENABLE=no" >> ${IB_CONF_DIR}/openib.conf
		echo "# PRIMARY_IPOIB_DEV=ib0" >> ${IB_CONF_DIR}/openib.conf
		echo "# SECONDARY_IPOIB_DEV=ib1" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use srp; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load SRP module" >> ${IB_CONF_DIR}/openib.conf
		echo "#SRP_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
		# from ofa_user.spec:
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Enable SRP High Availability daemon" >> ${IB_CONF_DIR}/openib.conf
		echo "#SRPHA_ENABLE=no" >> ${IB_CONF_DIR}/openib.conf

	fi
	if use rds; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load RDS module" >> ${IB_CONF_DIR}/openib.conf
		echo "#RDS_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
	fi

	doins "${T}/openib.conf"
}

pkg_postinst() {
	einfo "Configuration file installed in /etc/infiniband/openib.conf"
	einfo "To automatically initialize infiniband on boot, add openib to your"
	einfo "start-up scripts, like so:"
	einfo "\`rc-update add openib default\`"

}
