# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake-utils python-single-r1 udev systemd

DESCRIPTION="Userspace components for the Linux Kernel's drivers/infiniband subsystem"
HOMEPAGE="https://github.com/linux-rdma/rdma-core"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linux-rdma/rdma-core"
else
	SRC_URI="https://github.com/linux-rdma/rdma-core/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="|| ( GPL-2 ( CC0-1.0 MIT BSD BSD-with-attribution ) )"
SLOT="0"
IUSE="neigh python static-libs systemd valgrind"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	virtual/libudev:=
	neigh? ( dev-libs/libnl:3 )
	systemd? ( sys-apps/systemd:= )
	valgrind? ( dev-util/valgrind )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${COMMON_DEPEND}
	python? ( dev-python/cython[${PYTHON_USEDEP}] )"

RDEPEND="${COMMON_DEPEND}
	!!sys-fabric/infiniband-diags
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

BDEPEND="virtual/pkgconfig"

pkg_setup() {
	python-single-r1_pkg_setup

}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_FULL_RUNDIR=/run
		-DCMAKE_INSTALL_SHAREDSTATEDIR=/var/lib
		-DCMAKE_INSTALL_UDEV_RULESDIR="$(get_udevdir)"/rules.d
		-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR="$(systemd_get_systemunitdir)"
		-DCMAKE_DISABLE_FIND_PACKAGE_pandoc=yes
		$(ver_test -ge 25 && echo -DCMAKE_DISABLE_FIND_PACKAGE_rst2man=yes)
		-DCMAKE_DISABLE_FIND_PACKAGE_Systemd="$(usex systemd no yes)"
		-DENABLE_VALGRIND="$(usex valgrind)"
		-DENABLE_RESOLVE_NEIGH="$(usex neigh)"
		-DENABLE_STATIC="$(usex static-libs)"
	)

	if use python; then
		mycmakeargs+=( -DNO_PYVERBS=OFF )
	else
		mycmakeargs+=( -DNO_PYVERBS=ON )
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	udev_dorules "${D}"/etc/udev/rules.d/70-persistent-ipoib.rules
	rm -r "${D}"/etc/{udev,init.d} || die

	newinitd "${FILESDIR}"/ibacm.init ibacm
	newinitd "${FILESDIR}"/iwpmd.init iwpmd
	newinitd "${FILESDIR}"/srpd.init srpd
}
