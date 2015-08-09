# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

OFED_VER="3.5"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="OFED.3.5.rc2"

IUSE_OFED_DRIVERS="
		ofed_drivers_cxgb3
		ofed_drivers_cxgb4
		ofed_drivers_ehca
		ofed_drivers_ipath
		ofed_drivers_mlx4
		ofed_drivers_mthca
		ofed_drivers_nes
		ofed_drivers_psm"

inherit openib udev toolchain-funcs

DESCRIPTION="OpenIB system files"
SCRIPTDIR="${S}/ofed_scripts"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="compat-dapl dapl +diags ibacm mstflint +opensm perftest rds sdp srp ${IUSE_OFED_DRIVERS}"

RDEPEND="!sys-infiniband/openib
		!sys-infiniband/openib-files
		sys-infiniband/libibcm:${SLOT}
		sys-infiniband/libibmad:${SLOT}
		sys-infiniband/libibumad:${SLOT}
		sys-infiniband/librdmacm:${SLOT}
		compat-dapl? ( sys-infiniband/compat-dapl:${SLOT} )
		dapl? ( sys-infiniband/dapl:${SLOT} )
		diags? ( sys-infiniband/infiniband-diags:${SLOT} )
		ibacm? ( sys-infiniband/ibacm:${SLOT} )
		mstflint? ( sys-infiniband/mstflint:${SLOT} )
		opensm? ( sys-infiniband/opensm:${SLOT} )
		perftest? ( sys-infiniband/perftest:${SLOT} )
		srp? ( sys-infiniband/srptools:${SLOT} )
		ofed_drivers_cxgb3? ( sys-infiniband/libcxgb3:${SLOT} )
		ofed_drivers_cxgb4? ( sys-infiniband/libcxgb4:${SLOT} )
		ofed_drivers_ehca? ( sys-infiniband/libehca:${SLOT} )
		ofed_drivers_ipath? ( sys-infiniband/libipathverbs:${SLOT} )
		ofed_drivers_mlx4? ( sys-infiniband/libmlx4:${SLOT} )
		ofed_drivers_mthca? ( sys-infiniband/libmthca:${SLOT} )
		ofed_drivers_nes? ( sys-infiniband/libnes:${SLOT} )
		ofed_drivers_psm? ( sys-infiniband/infinipath-psm:${SLOT} )
		"
DEPEND="${RDEPEND}
		virtual/pkgconfig
		"

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
	build_sdp=1
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
	if (( build_sdp )); then
		 echo >> ${IB_CONF_DIR}/openib.conf
		 echo "# Load SDP module" >> ${IB_CONF_DIR}/openib.conf
		 echo "#SDP_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
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
	if use iser; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load ISER module" >> ${IB_CONF_DIR}/openib.conf
		echo "#ISER_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use rds; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load RDS module" >> ${IB_CONF_DIR}/openib.conf
		echo "#RDS_LOAD=no" >> ${IB_CONF_DIR}/openib.conf
	fi
	if use vnic; then
		echo >> ${IB_CONF_DIR}/openib.conf
		echo "# Load VNIC module" >> ${IB_CONF_DIR}/openib.conf
		echo "#VNIC_LOAD=yes" >> ${IB_CONF_DIR}/openib.conf
	fi

	doins "${T}/openib.conf"
}

pkg_postinst() {
	einfo "Configuration file installed in /etc/infiniband/openib.conf"
	einfo "To automatically initialize infiniband on boot, add openib to your"
	einfo "start-up scripts, like so:"
	einfo "\`rc-update add openib default\`"

}
