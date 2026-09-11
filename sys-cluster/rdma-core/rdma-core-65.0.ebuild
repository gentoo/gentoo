# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit cmake perl-functions python-single-r1 udev systemd

DESCRIPTION="Userspace components for the Linux Kernel's drivers/infiniband subsystem"
HOMEPAGE="https://github.com/linux-rdma/rdma-core"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linux-rdma/rdma-core"
else
	SRC_URI="https://github.com/linux-rdma/rdma-core/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="|| ( GPL-2 ( CC0-1.0 MIT BSD BSD-with-attribution ) )"
SLOT="0"
IUSE="lttng neigh python static-libs systemd valgrind"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-lang/perl:=
	virtual/libudev:=
	lttng? ( dev-util/lttng-ust:= )
	neigh? ( dev-libs/libnl:3 )
	systemd? ( sys-apps/systemd:= )
	valgrind? ( dev-debug/valgrind )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	python? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
		')
	)
"
# python is required unconditionally at build-time
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-39.0-RDMA_BuildType.patch
	"${FILESDIR}"/${PN}-65.0-lttng-static.patch
)

src_configure() {
	perl_set_version

	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_RUNDIR=/run
		-DCMAKE_INSTALL_SHAREDSTATEDIR="${EPREFIX}"/var/lib
		-DCMAKE_INSTALL_PERLDIR="${VENDOR_LIB}"
		-DCMAKE_INSTALL_UDEV_RULESDIR="${EPREFIX}$(get_udevdir)"/rules.d
		-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR="$(systemd_get_systemunitdir)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Systemd="$(usex !systemd)"
		-DTRACING="$(usex lttng LTTNG None)"
		-DENABLE_VALGRIND="$(usex valgrind)"
		-DENABLE_RESOLVE_NEIGH="$(usex neigh)"
		-DENABLE_STATIC="$(usex static-libs)"
		-DNO_PYVERBS="$(usex !python)"
		-DNO_MAN_PAGES=1
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	udev_dorules "${ED}"/usr/share/doc/${PF}/70-persistent-ipoib.rules

	if use neigh; then
		newinitd "${FILESDIR}"/ibacm.init ibacm
		newinitd "${FILESDIR}"/iwpmd.init iwpmd
	fi

	newinitd "${FILESDIR}"/srpd.init srpd

	use python && python_optimize
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
