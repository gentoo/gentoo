# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
CMAKE_MAKEFILE_GENERATOR=emake

DISTUTILS_OPTIONAL=1

inherit check-reqs bash-completion-r1 cmake distutils-r1 flag-o-matic \
		python-r1 udev readme.gentoo-r1 toolchain-funcs systemd tmpfiles

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ceph/ceph.git"
	SRC_URI=""
else
	SRC_URI="https://download.ceph.com/tarballs/${P}.tar.gz"
	KEYWORDS="amd64 ~ppc64"
fi

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="https://ceph.com/"

LICENSE="Apache-2.0 LGPL-2.1 CC-BY-SA-3.0 GPL-2 GPL-2+ LGPL-2+ LGPL-2.1 LGPL-3 GPL-3 BSD Boost-1.0 MIT public-domain"
SLOT="0"

CPU_FLAGS_X86=(sse{,2,3,4_1,4_2} ssse3)

IUSE="babeltrace +cephfs custom-cflags diskprediction dpdk fuse grafana jemalloc
	kafka kerberos ldap lttng +mgr numa rabbitmq +radosgw +ssl spdk system-boost
	systemd +tcmalloc test xfs zfs"
IUSE+=" $(printf "cpu_flags_x86_%s\n" ${CPU_FLAGS_X86[@]})"

DEPEND="
	acct-group/ceph
	acct-user/ceph
	virtual/libudev:=
	app-arch/bzip2:=
	app-arch/lz4:=
	app-arch/snappy:=
	app-arch/zstd:=
	app-shells/bash:0
	app-misc/jq:=
	dev-libs/crypto++:=
	dev-libs/leveldb:=[snappy,tcmalloc(-)?]
	dev-libs/libaio:=
	dev-libs/libnl:3=
	dev-libs/libxml2:=
	<dev-libs/rocksdb-6.15:=
	dev-libs/xmlsec:=[openssl]
	dev-cpp/yaml-cpp:=
	dev-libs/nss:=
	dev-libs/protobuf:=
	net-dns/c-ares:=
	net-libs/gnutls:=
	sys-auth/oath-toolkit:=
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/hwloc:=
	sys-apps/keyutils:=
	sys-apps/util-linux:=
	sys-apps/sed
	sys-apps/util-linux
	sys-libs/libcap-ng:=
	sys-libs/ncurses:0=
	sys-libs/zlib:=
	sys-process/numactl:=
	x11-libs/libpciaccess:=
	babeltrace? ( dev-util/babeltrace )
	fuse? ( sys-fs/fuse:0= )
	jemalloc? ( dev-libs/jemalloc:= )
	!jemalloc? ( >=dev-util/google-perftools-2.6.1:= )
	kafka? ( dev-libs/librdkafka:= )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	lttng? ( dev-util/lttng-ust:= )
	rabbitmq? ( net-libs/rabbitmq-c:= )
	radosgw? (
		dev-libs/expat:=
		dev-libs/openssl:=
		net-misc/curl:=[curl_ssl_openssl]
	)
	ssl? ( dev-libs/openssl:= )
	system-boost? ( dev-libs/boost[threads,context,python,${PYTHON_USEDEP}] )
	xfs? ( sys-fs/xfsprogs:= )
	zfs? ( sys-fs/zfs:= )
	${PYTHON_DEPS}
"
BDEPEND="
	amd64? ( dev-lang/yasm )
	x86? ( dev-lang/yasm )
	app-arch/cpio
	>=dev-util/cmake-3.5.0
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/sphinx
	dev-util/cunit
	dev-util/gperf
	dev-util/ragel
	dev-util/valgrind
	sys-apps/coreutils
	sys-apps/findutils
	sys-apps/grep
	sys-apps/sed
	sys-apps/which
	sys-devel/bc
	sys-devel/patch
	virtual/pkgconfig
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		sys-apps/grep[pcre]
		sys-fs/btrfs-progs
	)
"
RDEPEND="${DEPEND}
	app-admin/sudo
	net-misc/socat
	sys-apps/gptfdisk
	>=sys-apps/smartmontools-7.0
	sys-block/parted
	sys-fs/cryptsetup
	sys-fs/lsscsi
	sys-fs/lvm2[-device-mapper-only(-)]
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
	mgr? (
		dev-python/more-itertools[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyjwt[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/routes[${PYTHON_USEDEP}]
		diskprediction? (
			$(python_gen_cond_dep '<dev-python/scipy-1.4.0[${PYTHON_USEDEP}]' python3_{6,7})
		)
		sci-libs/scikit-learn[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"
# diskprediction needs older scipy not compatible with py38
# bug #724438
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	?? ( jemalloc tcmalloc )
	diskprediction? ( mgr !python_targets_python3_8 )
	kafka? ( radosgw )
	mgr? ( cephfs )
	rabbitmq? ( radosgw )
"
RESTRICT="!test? ( test )"

# the tests need root access
RESTRICT="test? ( userpriv )"

# distribution tarball does not include everything needed for tests
RESTRICT+=" test"

# create a non-debug release
CMAKE_BUILD_TYPE=RelWithDebInfo

# false positives unless all USE flags are on
CMAKE_WARN_UNUSED_CLI=no

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
	"${FILESDIR}/ceph-14.2.3-dpdk-compile-fix-1.patch"
	"${FILESDIR}/ceph-14.2.4-python-executable.patch"
	"${FILESDIR}/ceph-14.2.4-undefined-behaviour.patch"
	"${FILESDIR}/ceph-14.2.10-build-without-mgr.patch"
	"${FILESDIR}/ceph-14.2.11-systemd-unit-fix.patch"
	"${FILESDIR}/ceph-15.2.9-dont-compile-isal_compress-if-don-t-have-SSE4_1.patch"
)

check-reqs_export_vars() {
	CHECKREQS_DISK_BUILD="5200M"
	CHECKREQS_DISK_USR="510M"

	export CHECKREQS_DISK_BUILD CHECKREQS_DISK_USR
}

pkg_pretend() {
	check-reqs_export_vars
	check-reqs_pkg_pretend
}

pkg_setup() {
	python_setup
	check-reqs_export_vars
	check-reqs_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if use system-boost; then
		find "${S}" -name '*.cmake' -or -name 'CMakeLists.txt' -print0 \
			| xargs --null sed -r \
			-e 's|Boost::|boost_|g' \
			-e 's|Boost_|boost_|g' \
			-e 's|[Bb]oost_boost|boost_system|g' -i || die
	fi

	sed -r -e "s:DESTINATION .+\\):DESTINATION $(get_bashcompdir)\\):" \
		-i src/bash_completion/CMakeLists.txt || die

	sed  -e "s:objdump -p:$(tc-getOBJDUMP) -p:" -i CMakeLists.txt || die

	if ! use diskprediction; then
		rm -rf src/pybind/mgr/diskprediction_local || die
	fi

	# remove tests that need root access
	rm src/test/cli/ceph-authtool/cap*.t || die
}

ceph_src_configure() {
	local flag
	local mycmakeargs=(
		-DWITH_BABELTRACE=$(usex babeltrace)
		-DWITH_CEPHFS=$(usex cephfs)
		-DWITH_CEPHFS_SHELL=$(usex cephfs)
		-DWITH_DPDK=$(usex dpdk)
		-DWITH_SPDK=$(usex spdk)
		-DWITH_FUSE=$(usex fuse)
		-DWITH_LTTNG=$(usex lttng)
		-DWITH_GSSAPI=$(usex kerberos)
		-DWITH_GRAFANA=$(usex grafana)
		-DWITH_MGR=$(usex mgr)
		-DWITH_MGR_DASHBOARD_FRONTEND=OFF
		-DWITH_NUMA=$(usex numa)
		-DWITH_OPENLDAP=$(usex ldap)
		-DWITH_PYTHON3=3
		-DWITH_RADOSGW=$(usex radosgw)
		-DWITH_RADOSGW_AMQP_ENDPOINT=$(usex rabbitmq)
		-DWITH_RADOSGW_KAFKA_ENDPOINT=$(usex kafka)
		-DWITH_SSL=$(usex ssl)
		-DWITH_SYSTEMD=$(usex systemd)
		-DWITH_TESTS=$(usex test)
		-DWITH_XFS=$(usex xfs)
		-DWITH_ZFS=$(usex zfs)
		-DENABLE_SHARED="ON"
		-DALLOCATOR=$(usex tcmalloc 'tcmalloc' "$(usex jemalloc 'jemalloc' 'libc')")
		-DWITH_SYSTEM_BOOST=$(usex system-boost)
		-DBOOST_J=$(makeopts_jobs)
		-DWITH_SYSTEM_ROCKSDB=ON
		-DWITH_RDMA=OFF
		-DWITH_TBB=OFF
		-DSYSTEMD_UNITDIR=$(systemd_get_systemunitdir)
		-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR=$(systemd_get_systemunitdir)
		-DEPYTHON_VERSION="${EPYTHON#python}"
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PN}-${PVR}"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-Wno-dev
	)
	if use amd64 || use x86; then
		for flag in ${CPU_FLAGS_X86[@]}; do
			mycmakeargs+=("$(usex cpu_flags_x86_${flag} "-DHAVE_INTEL_${flag^^}=1")")
		done
	fi

	# needed for >=glibc-2.32
	has_version '>=sys-libs/glibc-2.32' && mycmakeargs+=(-DWITH_REENTRANT_STRSIGNAL:BOOL=ON)

	rm -f "${BUILD_DIR:-${S}}/CMakeCache.txt" \
		|| die "failed to remove cmake cache"

	cmake_src_configure

	# bug #630232
	sed -i "s:\"${T//:\\:}/${EPYTHON}/bin/python\":\"${PYTHON}\":" \
		"${BUILD_DIR:-${S}}"/include/acconfig.h \
		|| die "sed failed"
}

src_configure() {
	use custom-cflags || strip-flags
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
	cmake_build VERBOSE=1 all

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
	cmake_src_install
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
	newtmpfiles "${FILESDIR}"/ceph-tmpfilesd ${PN}.conf

	readme.gentoo_create_doc

	python_setup

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
