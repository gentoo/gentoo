# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7}} )
CMAKE_MAKEFILE_GENERATOR=emake

DISTUTILS_OPTIONAL=1

inherit check-reqs bash-completion-r1 cmake-utils distutils-r1 flag-o-matic \
		multiprocessing python-r1 udev readme.gentoo-r1 toolchain-funcs \
		systemd

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ceph/ceph.git"
	SRC_URI=""
else
	SRC_URI="https://download.ceph.com/tarballs/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
fi

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="https://ceph.com/"

LICENSE="LGPL-2.1 CC-BY-SA-3.0 GPL-2 GPL-2+ LGPL-2+ BSD Boost-1.0 MIT public-domain"
SLOT="0"

CPU_FLAGS_X86=(sse{,2,3,4_1,4_2} ssse3)

IUSE="babeltrace cephfs dpdk fuse grafana jemalloc kerberos ldap libressl"
IUSE+=" lttng +mgr numa rabbitmq +radosgw +ssl spdk static-libs system-boost"
IUSE+=" systemd +tcmalloc test xfs zfs"
IUSE+=" $(printf "cpu_flags_x86_%s\n" ${CPU_FLAGS_X86[@]})"

COMMON_DEPEND="
	acct-group/ceph
	acct-user/ceph
	virtual/libudev:=
	app-arch/bzip2:=[static-libs?]
	app-arch/lz4:=[static-libs?]
	app-arch/snappy:=[static-libs?]
	app-arch/zstd:=[static-libs?]
	app-shells/bash:0
	app-misc/jq:=[static-libs?]
	dev-libs/crypto++:=[static-libs?]
	dev-libs/leveldb:=[snappy,static-libs?,tcmalloc(-)?]
	dev-libs/libaio:=[static-libs?]
	dev-libs/libnl:3=[static-libs?]
	dev-libs/libxml2:=[static-libs?]
	dev-libs/nss:=
	sys-auth/oath-toolkit:=
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/keyutils:=[static-libs?]
	sys-apps/util-linux:=[static-libs?]
	sys-apps/sed
	sys-apps/util-linux
	sys-libs/libcap-ng:=[static-libs?]
	sys-libs/ncurses:0=[static-libs?]
	sys-libs/zlib:=[static-libs?]
	babeltrace? ( dev-util/babeltrace )
	ldap? ( net-nds/openldap:=[static-libs?] )
	lttng? ( dev-util/lttng-ust:= )
	fuse? ( sys-fs/fuse:0=[static-libs?] )
	kerberos? ( virtual/krb5 )
	rabbitmq? ( net-libs/rabbitmq-c:=[static-libs?] )
	ssl? (
		!libressl? ( dev-libs/openssl:=[static-libs?] )
		libressl? ( dev-libs/libressl:=[static-libs?] )
	)
	xfs? ( sys-fs/xfsprogs:=[static-libs(+)?] )
	zfs? ( sys-fs/zfs:=[static-libs?] )
	radosgw? (
		dev-libs/expat:=[static-libs?]
		!libressl? (
			dev-libs/openssl:=[static-libs?]
			net-misc/curl:=[curl_ssl_openssl,static-libs?]
		)
		libressl? (
			dev-libs/libressl:=[static-libs?]
			net-misc/curl:=[curl_ssl_libressl,static-libs?]
		)
	)
	system-boost? (
		|| (
			=dev-libs/boost-1.71*[threads,context,python,static-libs?,${PYTHON_USEDEP}]
			=dev-libs/boost-1.70*[threads,context,python,static-libs?,${PYTHON_USEDEP}]
			=dev-libs/boost-1.67*[threads,context,python,static-libs?,${PYTHON_USEDEP}]
		)
		dev-libs/boost:=[threads,context,python,static-libs?,${PYTHON_USEDEP}]
	)
	jemalloc? ( dev-libs/jemalloc:=[static-libs?] )
	!jemalloc? ( >=dev-util/google-perftools-2.4:=[static-libs?] )
	${PYTHON_DEPS}
"
DEPEND="${COMMON_DEPEND}
	amd64? ( dev-lang/yasm )
	x86? ( dev-lang/yasm )
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/sphinx
	dev-util/cunit
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		sys-apps/grep[pcre]
		sys-fs/btrfs-progs
	)
"
BDEPEND="
	app-arch/cpio
	>=dev-util/cmake-3.5.0
	dev-util/gperf
	dev-util/valgrind
	sys-apps/coreutils
	sys-apps/findutils
	sys-apps/grep
	sys-apps/sed
	sys-apps/which
	sys-devel/bc
	sys-devel/patch
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	net-misc/socat
	sys-apps/gptfdisk
	sys-block/parted
	sys-fs/cryptsetup
	sys-fs/lvm2[-device-mapper-only(-)]
	sys-fs/lsscsi
	virtual/awk
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/cherrypy[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pecan[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( $(python_gen_useflags 'python3*') )
	?? ( jemalloc tcmalloc )
	rabbitmq? ( radosgw )
"

# the tests need root access
RESTRICT="test? ( userpriv )"

# distribution tarball does not include everything needed for tests
RESTRICT+=" test"

# false positives unless all USE flags are on
CMAKE_WARN_UNUSED_CLI="no"

PATCHES=(
	"${FILESDIR}/ceph-12.2.0-use-provided-cpu-flag-values.patch"
	"${FILESDIR}/ceph-14.2.0-cflags.patch"
	"${FILESDIR}/ceph-12.2.4-boost-build-none-options.patch"
	"${FILESDIR}/ceph-13.2.0-cflags.patch"
	"${FILESDIR}/ceph-14.2.0-mgr-python-version.patch"
	"${FILESDIR}/ceph-14.2.5-no-virtualenvs.patch"
	"${FILESDIR}/ceph-13.2.2-dont-install-sysvinit-script.patch"
	"${FILESDIR}/ceph-14.2.0-dpdk-cflags.patch"
	"${FILESDIR}/ceph-14.2.0-link-crc32-statically.patch"
	"${FILESDIR}/ceph-14.2.0-cython-0.29.patch"
	"${FILESDIR}/ceph-14.2.5-boost-1.70.patch"
	"${FILESDIR}/ceph-14.2.3-dpdk-compile-fix-1.patch"
	"${FILESDIR}/ceph-14.2.4-python-executable.patch"
	"${FILESDIR}/ceph-14.2.4-undefined-behaviour.patch"
)

check-reqs_export_vars() {
	if use amd64; then
		CHECKREQS_DISK_BUILD="12G"
		CHECKREQS_DISK_USR="460M"
	else
		CHECKREQS_DISK_BUILD="1400M"
		CHECKREQS_DISK_USR="450M"
	fi

	export CHECKREQS_DISK_BUILD CHECKREQS_DISK_USR
}

pkg_pretend() {
	check-reqs_export_vars
	check-reqs_pkg_pretend
}

pkg_setup() {
	python_setup 'python3*'
	check-reqs_export_vars
	check-reqs_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	if use system-boost; then
		eapply "${FILESDIR}/ceph-14.2.5-boost-sonames.patch"

		find "${S}" -name '*.cmake' -or -name 'CMakeLists.txt' -print0 \
			| xargs --null sed -e 's|Boost::|Boost_|g' -i || die

		has_version '>=dev-libs/boost-1.70.0' || \
			eapply "${FILESDIR}/ceph-14.2.5-boost-1.6-python-sonames.patch"
	fi

	sed -i -r "s:DESTINATION .+\\):DESTINATION $(get_bashcompdir)\\):" \
		src/bash_completion/CMakeLists.txt || die

	# remove tests that need root access
	rm src/test/cli/ceph-authtool/cap*.t || die
}

ceph_src_configure() {
	local flag
	local mycmakeargs=(
		-DWITH_BABELTRACE=$(usex babeltrace)
		-DWITH_CEPHFS=$(usex cephfs)
		-DWITH_CEPHFS_SHELL=$(if python_is_python3; then usex cephfs; else echo OFF; fi)
		-DWITH_DPDK=$(usex dpdk)
		-DWITH_DPDK=$(usex spdk)
		-DWITH_FUSE=$(usex fuse)
		-DWITH_LTTNG=$(usex lttng)
		-DWITH_GSSAPI=$(usex kerberos)
		-DWITH_GRAFANA=$(usex grafana)
		-DWITH_MGR=$(usex mgr)
		-DWITH_MGR_DASHBOARD_FRONTEND=NO
		-DWITH_NUMA=$(usex numa)
		-DWITH_OPENLDAP=$(usex ldap)
		-DMGR_PYTHON_VERSION=$(if python_is_python3; then echo 3; else echo 2; fi)
		-DWITH_PYTHON3=$(if python_is_python3; then echo "ON"; else echo "OFF"; fi)
		-DWITH_PYTHON2=$(if python_is_python3; then echo "OFF"; else echo "ON"; fi)
		-DWITH_RADOSGW=$(usex radosgw)
		-DWITH_RADOSGW_AMQP_ENDPOINT=$(usex rabbitmq)
		-DWITH_SSL=$(usex ssl)
		-DWITH_SYSTEMD=$(usex systemd)
		-DWITH_TESTS=$(usex test)
		-DWITH_XFS=$(usex xfs)
		-DWITH_ZFS=$(usex zfs)
		-DENABLE_SHARED=$(usex static-libs '' 'ON' 'OFF')
		-DALLOCATOR=$(usex tcmalloc 'tcmalloc' "$(usex jemalloc 'jemalloc' 'libc')")
		-DWITH_SYSTEM_BOOST=$(usex system-boost)
		-DBOOST_J=$(makeopts_jobs)
		-DWITH_RDMA=no
		-DWITH_TBB=no
		-DSYSTEMD_UNITDIR=$(systemd_get_systemunitdir)
		-DEPYTHON_VERSION="${EPYTHON#python}"
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PN}-${PVR}"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		#-Wno-dev
	)
	if use amd64 || use x86; then
		for flag in ${CPU_FLAGS_X86[@]}; do
			mycmakeargs+=("$(usex cpu_flags_x86_${flag} "-DHAVE_INTEL_${flag^^}=1")")
		done
	fi

	rm -f "${BUILD_DIR:-${S}}/CMakeCache.txt" \
		|| die "failed to remove cmake cache"

	cmake-utils_src_configure

	# bug #630232
	sed -i "s:\"${T//:\\:}/${EPYTHON}/bin/python\":\"${PYTHON}\":" \
		"${BUILD_DIR:-${S}}"/include/acconfig.h \
		|| die "sed failed"
}

src_configure() {
	ceph_src_configure
}

python_compile() {
	local CMAKE_USE_DIR="${S}"
	ceph_src_configure

	pushd "${BUILD_DIR}/src/pybind" >/dev/null || die
	emake VERBOSE=1 clean
	emake VERBOSE=1 all

	# python modules are only compiled with "make install" so we need to do this to
	# prevent doing a bunch of compilation in src_install
	DESTDIR="${T}" emake VERBOSE=1 install
	popd >/dev/null || die
}

src_compile() {
	cmake-utils_src_make VERBOSE=1 all

	# we have to do this here to prevent from building everything multiple times
	python_copy_sources
	python_foreach_impl python_compile
}

src_test() {
	make check || die "make check failed"
}

python_install() {
	local CMAKE_USE_DIR="${S}"
	pushd "${BUILD_DIR}/src/pybind" >/dev/null || die
	DESTDIR="${ED}" emake VERBOSE=1 install
	popd >/dev/null || die

	python_optimize
}

src_install() {
	cmake-utils_src_install
	python_foreach_impl python_install

	find "${ED}" -name '*.la' -type f -delete || die

	exeinto /usr/$(get_libdir)/ceph
	newexe "${BUILD_DIR}/bin/init-ceph" init-ceph

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/ceph.logrotate-r2 ${PN}

	keepdir /var/lib/${PN}{,/tmp} /var/log/${PN}/stat

	fowners -R ceph:ceph /var/log/ceph

	newinitd "${FILESDIR}/rbdmap.initd" rbdmap
	newinitd "${FILESDIR}/${PN}.initd-r12" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r5" ${PN}

	insinto /etc/sysctl.d
	newins "${FILESDIR}"/sysctld 90-${PN}.conf

	use tcmalloc && newenvd "${FILESDIR}"/envd-tcmalloc 99${PN}-tcmalloc

	# units aren't installed by the build system unless systemd is enabled
	# so no point installing these with the USE flag disabled
	if use systemd; then
		systemd_install_serviced "${FILESDIR}/ceph-mds_at.service.conf" \
			"ceph-mds@.service"

		systemd_install_serviced "${FILESDIR}/ceph-osd_at.service.conf" \
			"ceph-osd@.service"
	fi

	udev_dorules udev/*.rules

	readme.gentoo_create_doc

	python_setup 'python3*'

	# bug #630232
	sed -i -r "s:${T//:/\\:}/${EPYTHON}:/usr:" "${ED}"/usr/bin/ceph{,-crash} \
		|| die "sed failed"

	python_fix_shebang "${ED}"/usr/{,s}bin/

	# python_fix_shebang apparently is not idempotent
	local shebang_regex='(/usr/lib/python-exec/python[0-9]\.[0-9]/python)[0-9]\.[0-9]'
	grep -r -E -l --null "${shebang_regex}" "${ED}"/usr/{s,}bin/ \
		| xargs --null --no-run-if-empty -- sed -i -r  "s:${shebang_regex}:\1:" || die

	local -a rados_classes=( "${ED}/usr/$(get_libdir)/rados-classes"/* )
	dostrip -x "${rados_classes[@]#${ED}}"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
