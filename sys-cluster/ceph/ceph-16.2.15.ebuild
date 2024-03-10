# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
LUA_COMPAT=( lua5-3 )
CMAKE_MAKEFILE_GENERATOR=emake

inherit check-reqs bash-completion-r1 cmake python-r1 flag-o-matic \
		lua-single udev readme.gentoo-r1 toolchain-funcs systemd tmpfiles

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="https://ceph.com/"

SRC_URI="https://download.ceph.com/tarballs/${P}.tar.gz"
LICENSE="Apache-2.0 LGPL-2.1 CC-BY-SA-3.0 GPL-2 GPL-2+ LGPL-2+ LGPL-2.1 LGPL-3 GPL-3 BSD Boost-1.0 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

CPU_FLAGS_X86=(avx2 avx512f pclmul sse{,2,3,4_1,4_2} ssse3)

IUSE="
	babeltrace +cephfs custom-cflags diskprediction dpdk fuse grafana
	jemalloc jaeger kafka kerberos ldap lttng +mgr numa pmdk rabbitmq
	+radosgw rbd-rwl rbd-ssd rdma rgw-lua selinux +ssl spdk +sqlite +system-boost
	systemd +tcmalloc test uring xfs zbd zfs
"

IUSE+="$(printf "cpu_flags_x86_%s\n" ${CPU_FLAGS_X86[@]})"

DEPEND="
	${LUA_DEPS}
	${PYTHON_DEPS}
	acct-group/ceph
	acct-user/ceph
	virtual/libudev:=
	app-arch/bzip2:=
	app-arch/lz4:=
	app-arch/snappy:=
	>=app-arch/snappy-1.1.9-r1
	app-arch/zstd:=
	app-shells/bash:0
	app-misc/jq:=
	dev-cpp/gflags:=
	<dev-libs/leveldb-1.23:=[snappy,tcmalloc(-)?]
	dev-libs/libaio:=
	dev-libs/libnl:3=
	dev-libs/libxml2:=
	dev-libs/libevent:=
	dev-libs/openssl:=
	<dev-libs/rocksdb-6.15:=
	dev-libs/xmlsec:=[openssl]
	dev-cpp/yaml-cpp:=
	dev-libs/nss:=
	dev-libs/protobuf:=
	net-dns/c-ares:=
	net-libs/gnutls:=
	sys-auth/oath-toolkit:=
	sys-apps/coreutils
	sys-apps/hwloc:=
	sys-apps/keyutils:=
	sys-apps/util-linux:=
	sys-apps/util-linux
	sys-libs/libcap-ng:=
	sys-libs/ncurses:0=
	sys-libs/zlib:=
	sys-process/numactl:=
	virtual/libcrypt:=
	x11-libs/libpciaccess:=
	babeltrace? ( dev-util/babeltrace:0/1 )
	fuse? ( sys-fs/fuse:3= )
	jemalloc? ( dev-libs/jemalloc:= )
	!jemalloc? ( >=dev-util/google-perftools-2.6.1:= )
	jaeger? ( dev-cpp/nlohmann_json:= )
	kafka? ( dev-libs/librdkafka:= )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	lttng? ( dev-util/lttng-ust:= )
	pmdk? ( dev-libs/pmdk:= )
	rabbitmq? ( net-libs/rabbitmq-c:= )
	radosgw? (
		dev-libs/icu:=
		dev-libs/expat:=
		net-misc/curl:=[curl_ssl_openssl]
	)
	rbd-rwl? ( dev-libs/pmdk:= )
	rdma? ( sys-cluster/rdma-core:= )
	spdk? ( dev-util/cunit )
	sqlite? ( dev-db/sqlite:= )
	system-boost? ( dev-libs/boost:=[context,python,${PYTHON_USEDEP},zlib] )
	!system-boost? ( $(python_gen_impl_dep '' 3.{10..11}) )
	uring? ( sys-libs/liburing:= )
	xfs? ( sys-fs/xfsprogs:= )
	zbd? ( sys-block/libzbd:= )
	zfs? ( sys-fs/zfs:= )
"
# <cython-3: bug #907739
BDEPEND="
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/yasm )
	app-alternatives/cpio
	dev-debug/valgrind
	>=dev-build/cmake-3.5.0
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx
	dev-util/gperf
	dev-util/ragel
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/util-linux
	sys-apps/which
	app-alternatives/bc
	sys-devel/patch
	virtual/pkgconfig
	jaeger? (
		app-alternatives/yacc
		app-alternatives/lex
	)
	test? (
		dev-util/cunit
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		sys-apps/grep[pcre]
		sys-fs/btrfs-progs
	)
"
RDEPEND="
	${DEPEND}
	app-admin/sudo
	net-misc/socat
	sys-apps/gptfdisk
	sys-apps/nvme-cli
	>=sys-apps/smartmontools-7.0
	sys-block/parted
	sys-fs/cryptsetup
	sys-fs/lsscsi
	sys-fs/lvm2[lvm]
	app-alternatives/awk
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/cherrypy[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pecan[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	mgr? (
		dev-python/jsonpatch[${PYTHON_USEDEP}]
		dev-python/more-itertools[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyjwt[${PYTHON_USEDEP}]
		dev-python/routes[${PYTHON_USEDEP}]
		diskprediction? (
			>=dev-python/scipy-1.4.0[${PYTHON_USEDEP}]
		)
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
	selinux? ( sec-policy/selinux-ceph )
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	${LUA_REQUIRED_USE}
	?? ( jemalloc tcmalloc )
	jaeger? ( !system-boost )
	diskprediction? ( mgr )
	kafka? ( radosgw )
	mgr? ( cephfs )
	rabbitmq? ( radosgw )
	!system-boost? (
		python_targets_python3_10
	)
"

RESTRICT="
	!test? ( test )
"

# tests need root access, and network access
RESTRICT+="test"

# create a non-debug release
CMAKE_BUILD_TYPE=RelWithDebInfo

# false positives unless all USE flags are on
CMAKE_WARN_UNUSED_CLI=no

PATCHES=(
	"${FILESDIR}/ceph-12.2.0-use-provided-cpu-flag-values.patch"
	"${FILESDIR}/ceph-14.2.0-cflags.patch"
	"${FILESDIR}/ceph-12.2.4-boost-build-none-options.patch"
	"${FILESDIR}/ceph-16.2.2-cflags.patch"
	"${FILESDIR}/ceph-16.2.8-no-virtualenvs.patch"
	"${FILESDIR}/ceph-13.2.2-dont-install-sysvinit-script.patch"
	"${FILESDIR}/ceph-14.2.0-dpdk-cflags.patch"
	"${FILESDIR}/ceph-14.2.0-cython-0.29.patch"
	"${FILESDIR}/ceph-16.2.0-rocksdb-cmake.patch"
	"${FILESDIR}/ceph-15.2.3-spdk-compile.patch"
	"${FILESDIR}/ceph-16.2.0-spdk-tinfo.patch"
	"${FILESDIR}/ceph-16.2.0-jaeger-system-boost.patch"
	"${FILESDIR}/ceph-16.2.0-liburing.patch"
	"${FILESDIR}/ceph-16.2.2-system-zstd.patch"
	"${FILESDIR}/ceph-17.2.0-fuse3.patch"
	"${FILESDIR}/ceph-17.2.0-gcc12-header.patch"
	"${FILESDIR}/ceph-16.2.10-flags.patch"
	"${FILESDIR}/ceph-17.2.5-boost-1.81.patch"
	"${FILESDIR}/ceph-16.2.14-gcc13.patch"
	# https://bugs.gentoo.org/907739
	"${FILESDIR}/ceph-18.2.0-cython3.patch"
)

check-reqs_export_vars() {
	CHECKREQS_DISK_BUILD="6G"

	if use system-boost; then
		CHECKREQS_DISK_USR="350M"
	else
		CHECKREQS_DISK_USR="510M"
	fi

	export CHECKREQS_DISK_BUILD CHECKREQS_DISK_USR
}

pkg_pretend() {
	check-reqs_export_vars
	check-reqs_pkg_pretend
}

pkg_setup() {
	if ! use system-boost; then
		python_setup 3.10
	else
		python_setup
	fi
	lua_setup
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
			-e 's|[Bb]oost_boost|boost_system|g' \
			-i || die
	fi

	if ! use systemd; then
		find "${S}"/src/ceph-volume/ceph_volume -name '*.py' -print0 \
			| xargs --null sed \
			-e '/^from ceph_volume.systemd import systemctl/ d' \
			-i || die
	fi

	sed -r -e "s:DESTINATION .+\\):DESTINATION $(get_bashcompdir)\\):" \
		-i src/bash_completion/CMakeLists.txt || die

	sed  -e "s:objdump -p:$(tc-getOBJDUMP) -p:" -i CMakeLists.txt || die

	if ! use diskprediction; then
		rm -rf src/pybind/mgr/diskprediction_local || die
	fi

	# force lua version to use selected version
	local lua_version
	lua_version=$(ver_cut 1-2 $(lua_get_version))
	sed "s:find_package(Lua [0-9][.][0-9] REQUIRED):find_package(Lua ${lua_version} EXACT REQUIRED):" \
		-i src/CMakeLists.txt

	# remove tests that need root access
	rm src/test/cli/ceph-authtool/cap*.t || die
}

ceph_src_configure() {
	local mycmakeargs=(
		-DWITH_BABELTRACE:BOOL=$(usex babeltrace)
		-DWITH_BLUESTORE_PMEM:BOOL=$(usex pmdk)
		-DWITH_CEPHFS:BOOL=$(usex cephfs)
		-DWITH_CEPHFS_SHELL:BOOL=$(usex cephfs)
		-DWITH_DPDK:BOOL=$(usex dpdk)
		-DWITH_SPDK:BOOL=$(usex spdk)
		-DWITH_FUSE:BOOL=$(usex fuse)
		-DWITH_LTTNG:BOOL=$(usex lttng)
		-DWITH_GSSAPI:BOOL=$(usex kerberos)
		-DWITH_GRAFANA:BOOL=$(usex grafana)
		-DWITH_MGR:BOOL=$(usex mgr)
		-DWITH_MGR_DASHBOARD_FRONTEND:BOOL=OFF
		-DWITH_OPENLDAP:BOOL=$(usex ldap)
		-DWITH_PYTHON3:STRING=3
		-DWITH_RADOSGW:BOOL=$(usex radosgw)
		-DWITH_RADOSGW_AMQP_ENDPOINT:BOOL=$(usex rabbitmq)
		-DWITH_RADOSGW_KAFKA_ENDPOINT:BOOL=$(usex kafka)
		-DWITH_RADOSGW_LUA_PACKAGES:BOOL=$(usex rgw-lua "$(usex radosgw)" "NO")
		-DWITH_RBD_RWL:BOOL=$(usex rbd-rwl)
		-DWITH_RBD_SSD_CACHE:BOOL=$(usex rbd-ssd)
		-DWITH_SYSTEMD:BOOL=$(usex systemd)
		-DWITH_TESTS:BOOL=$(usex test)
		-DWITH_LIBURING:BOOL=$(usex uring)
		-DWITH_SYSTEM_LIBURING:BOOL=$(usex uring)
		-DWITH_LIBCEPHSQLITE:BOOL=$(usex sqlite)
		-DWITH_XFS:BOOL=$(usex xfs)
		-DWITH_ZBD:BOOL=$(usex zbd)
		-DWITH_ZFS:BOOL=$(usex zfs)
		-DENABLE_SHARED:BOOL=ON
		-DALLOCATOR:STRING=$(usex tcmalloc 'tcmalloc' "$(usex jemalloc 'jemalloc' 'libc')")
		-DWITH_SYSTEM_PMDK:BOOL=$(usex pmdk 'YES' "$(usex rbd-rwl)")
		-DWITH_SYSTEM_BOOST:BOOL=$(usex system-boost)
		-DWITH_SYSTEM_ROCKSDB:BOOL=ON
		-DWITH_RDMA:BOOL=$(usex rdma)
		-DCMAKE_INSTALL_DOCDIR:PATH="${EPREFIX}/usr/share/doc/${PN}-${PVR}"
		-DCMAKE_INSTALL_SYSCONFDIR:PATH="${EPREFIX}/etc"
		# use the bundled libfmt for now since they seem to constantly break their API
		-DCMAKE_DISABLE_FIND_PACKAGE_fmt=ON
		-Wno-dev
	)

	# this breaks when re-configuring for python impl
	if [[ ${EBUILD_PHASE} == configure ]]; then
		mycmakeargs+=(
			-DWITH_JAEGER:BOOL=$(usex jaeger)
		)
	else
		mycmakeargs+=(
			-DWITH_RADOSGW_SELECT_PARQUET:BOOL=OFF
		)
	fi

	# conditionally used cmake args
	use test && mycmakearts+=( -DWITH_SYSTEM_GTEST:BOOL=$(usex test) )
	use systemd && mycmakeargs+=( -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=$(systemd_get_systemunitdir) )

	if use amd64 || use x86; then
		local flag
		for flag in "${CPU_FLAGS_X86[@]}"; do
			case "${flag}" in
				avx*)
					local var=${flag%f}
					mycmakeargs+=(
						"-DHAVE_NASM_X64_${var^^}:BOOL=$(usex cpu_flags_x86_${flag})"
					)
				;;
				*) mycmakeargs+=(
						"-DHAVE_INTEL_${flag^^}:BOOL=$(usex cpu_flags_x86_${flag})"
					);;
			esac
		done
	fi

	# needed for >=glibc-2.32
	has_version '>=sys-libs/glibc-2.32' && mycmakeargs+=( -DWITH_REENTRANT_STRSIGNAL:BOOL=ON )

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

src_compile() {
	cmake_build VERBOSE=1 all

	# we have to do this here to prevent from building everything multiple times
	python_copy_sources
	python_foreach_impl python_compile
}

python_compile() {
	local CMAKE_USE_DIR="${S}"
	ceph_src_configure

	pushd "${BUILD_DIR}/src/pybind" >/dev/null || die
	cmake_build VERBOSE=1 clean
	cmake_build VERBOSE=1 all

	# python modules are only compiled with "make install" so we need to do this to
	# prevent doing a bunch of compilation in src_install
	DESTDIR="${T}" cmake_build VERBOSE=1 install
	popd >/dev/null || die
}

src_install() {
	python_foreach_impl python_install

	python_setup
	cmake_src_install

	# the cmake_src_install here installs more egg-info files
	rm -rf "${D}/$(python_get_sitedir)"/*.egg-info || die

	find "${ED}" -name '*.la' -type f -delete || die

	exeinto /usr/$(get_libdir)/ceph
	newexe "${BUILD_DIR}/bin/init-ceph" init-ceph

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/ceph.logrotate-r2 ${PN}

	keepdir /var/lib/${PN}{,/tmp} /var/log/ceph/stat /var/log/ceph/console

	fowners -R ceph:ceph /var/log/ceph

	newinitd "${FILESDIR}/rbdmap.initd-r1" rbdmap
	newinitd "${FILESDIR}/${PN}.initd-r13" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r5" ${PN}

	insinto /etc/sudoers.d
	doins sudoers.d/*

	insinto /etc/sysctl.d
	newins "${FILESDIR}"/sysctld 90-${PN}.conf

	use tcmalloc && newenvd "${FILESDIR}"/envd-tcmalloc 99${PN}-tcmalloc

	# units aren't installed by the build system unless systemd is enabled
	# so no point installing these with the USE flag disabled
	if use systemd; then
		systemd_install_serviced "${FILESDIR}/ceph-mds_at.service.conf" "ceph-mds@.service"
		systemd_install_serviced "${FILESDIR}/ceph-osd_at.service.conf" "ceph-osd@.service"
	fi

	udev_dorules udev/*.rules
	newtmpfiles "${FILESDIR}"/ceph-tmpfilesd ${PN}.conf

	readme.gentoo_create_doc

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

python_install() {
	local CMAKE_USE_DIR="${S}"
	pushd "${BUILD_DIR}/src/pybind" >/dev/null || die
	DESTDIR="${ED}" cmake_build VERBOSE=1 install
	popd >/dev/null || die

	rm -rf "${D}/$(python_get_sitedir)"/*.egg-info || die

	python_scriptinto /usr/sbin
	python_doscript src/cephadm/cephadm

	python_optimize
}

pkg_postinst() {
	readme.gentoo_print_elog
	tmpfiles_process ${PN}.conf
	udev_reload
}

pkg_postrm() {
	udev_reload
}
