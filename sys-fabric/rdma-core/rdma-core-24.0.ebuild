# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit cmake-utils multilib-minimal python-r1 udev systemd

DESCRIPTION="Userspace components for the Linux Kernel's drivers/infiniband subsystem"
HOMEPAGE="https://github.com/linux-rdma/rdma-core"
SRC_URI="https://github.com/linux-rdma/rdma-core/releases/download/v${PV}/rdma-core-${PV}.tar.gz"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux"
IUSE="+neigh python static-libs systemd valgrind"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="
	virtual/libudev:=[${MULTILIB_USEDEP}]
	neigh? ( dev-libs/libnl:3[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:=[${MULTILIB_USEDEP}] )
	valgrind? ( dev-util/valgrind )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${CDEPEND}
	python? ( dev-python/cython[${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}
	!sys-fabric/libibverbs
	!sys-fabric/librdmacm
	!sys-fabric/libibumad
	!sys-fabric/ibacm
	!sys-fabric/libibmad
	!sys-fabric/srptools
	!sys-fabric/infinipath-psm
	!sys-fabric/libcxgb3
	!sys-fabric/libcxgb4
	!sys-fabric/libmthca
	!sys-fabric/libmlx4
	!sys-fabric/libmlx5
	!sys-fabric/libocrdma
	!sys-fabric/libnes"
BDEPEND="${PYTHON_DEPS}"

is_best_python() {
	[[ "${EPYTHON}" == "$(python_setup && echo "${EPYTHON}")" ]]
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_FULL_RUNDIR=/run
		-DCMAKE_INSTALL_UDEV_RULESDIR="$(get_udevdir)"/rules.d
		-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR="$(systemd_get_systemunitdir)"
		-DCMAKE_DISABLE_FIND_PACKAGE_pandoc=yes
		$(ver_test -ge 25 && echo -DCMAKE_DISABLE_FIND_PACKAGE_rst2man=yes)
		-DCMAKE_DISABLE_FIND_PACKAGE_Systemd="$(usex systemd no yes)"
		-DENABLE_VALGRIND="$(usex valgrind)"
		-DENABLE_RESOLVE_NEIGH="$(usex neigh)"
		-DENABLE_STATIC="$(usex static-libs)"
	)

	if use python && multilib_is_native_abi; then
		python_foreach_impl cmake-utils_src_configure
		return
	fi

	local mycmakeargs+=(
		-DNO_PYVERBS=ON
	)

	python_setup
	cmake-utils_src_configure
}

rdma_python_impl_compile() {
	if is_best_python; then
		cmake-utils_src_compile
	else
		cmake-utils_src_make pyverbs/all
	fi
}

multilib_src_compile() {
	if use python && multilib_is_native_abi; then
		python_foreach_impl rdma_python_impl_compile
		return
	fi

	cmake-utils_src_compile
}

rdma_python_impl_install() {
	if is_best_python; then
		cmake-utils_src_install
	else
		DESTDIR="${ED}" cmake-utils_src_make pyverbs/install
	fi
}

multilib_src_install() {
	if use python && multilib_is_native_abi; then
		python_foreach_impl rdma_python_impl_install
		return
	fi

	cmake-utils_src_install
}

multilib_src_install_all() {
	udev_dorules "${ED}"/etc/udev/rules.d/*
	rm -r "${ED}"/etc/{udev,init.d} || die

	newinitd "${FILESDIR}"/ibacm.init ibacm
	newinitd "${FILESDIR}"/iwpmd.init iwpmd
	newinitd "${FILESDIR}"/srpd.init srpd
}
