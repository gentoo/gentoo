# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_WARN_UNUSED_CLI=no # false positives unless all USE flags are on
PYTHON_COMPAT=( python3_{10..13} )
LUA_COMPAT=( lua5-{3..4} )

inherit check-reqs bash-completion-r1 cmake flag-o-matic lua-single multiprocessing \
		python-r1 udev readme.gentoo-r1 toolchain-funcs systemd tmpfiles

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="https://ceph.com/"

SRC_URI="
	https://download.ceph.com/tarballs/${P}.tar.gz
	parquet? ( https://github.com/xtensor-stack/xsimd/archive/13.0.0.tar.gz -> ceph-xsimd-${PV}.tar.gz
		mirror://apache/arrow/arrow-17.0.0/apache-arrow-17.0.0.tar.gz )
	parquet? ( mirror://apache/arrow/arrow-17.0.0/apache-arrow-17.0.0.tar.gz )
"

LICENSE="Apache-2.0 LGPL-2.1 CC-BY-SA-3.0 GPL-2 GPL-2+ LGPL-2+ LGPL-2.1 LGPL-3 GPL-3 BSD Boost-1.0 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"

IUSE="
	babeltrace +cephfs custom-cflags diskprediction dpdk fuse grafana
	jemalloc jaeger kafka kerberos ldap lttng +mgr nvmeof +parquet pmdk rabbitmq
	+radosgw rbd-rwl rbd-ssd rdma rgw-lua selinux +ssl spdk +sqlite +system-boost
	systemd +tcmalloc test +uring xfs zbd
"

CPU_FLAGS_X86=(avx2 avx512f pclmul sse{,2,3,4_1,4_2} ssse3)
IUSE+="$(printf "cpu_flags_x86_%s\n" ${CPU_FLAGS_X86[@]})"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	${LUA_REQUIRED_USE}
	?? ( jemalloc tcmalloc )
	diskprediction? ( mgr )
	kafka? ( radosgw )
	mgr? ( cephfs )
	rabbitmq? ( radosgw )
	rgw-lua? ( radosgw )
	nvmeof? ( spdk )
"

RESTRICT="!test? ( test )"

# tests need root access, and network access
RESTRICT+=" test"

DEPEND="
	${LUA_DEPS}
	${PYTHON_DEPS}
	acct-group/ceph
	acct-user/ceph
	virtual/libudev:=
	app-arch/bzip2:=
	app-arch/lz4:=
	>=app-arch/snappy-1.1.9-r1:=
	app-arch/zstd:=
	app-shells/bash:0
	app-misc/jq:=
	dev-cpp/gflags:=
	dev-db/lmdb:=
	dev-lang/jsonnet:=
	dev-libs/libaio:=
	dev-libs/libnl:3=
	dev-libs/libevent:=
	dev-libs/libutf8proc:=
	dev-libs/nss:=
	dev-libs/openssl:=
	<dev-libs/rocksdb-7.9.3:=
	dev-libs/thrift:=
	dev-libs/xmlsec:=[openssl]
	dev-cpp/yaml-cpp:=
	dev-python/natsort[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-vcs/git
	net-dns/c-ares:=
	net-libs/gnutls:=
	sys-auth/oath-toolkit:=
	sys-apps/coreutils
	sys-apps/hwloc:=
	sys-apps/keyutils:=
	sys-apps/util-linux:=
	sys-libs/libcap-ng:=
	sys-libs/libnbd
	sys-libs/ncurses:0=
	virtual/zlib:=
	sys-process/numactl:=
	virtual/libcrypt:=
	x11-libs/libpciaccess:=
	babeltrace? ( dev-util/babeltrace:0/1 )
	fuse? ( sys-fs/fuse:3= )
	jemalloc? ( dev-libs/jemalloc:= )
	!jemalloc? ( >=dev-util/google-perftools-2.6.1:= )
	jaeger? (
		dev-cpp/nlohmann_json:=
		<dev-cpp/opentelemetry-cpp-1.10:=[jaeger,prometheus]
	)
	kafka? ( dev-libs/librdkafka:= )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	lttng? ( dev-util/lttng-ust:= )
	nvmeof? ( net-libs/grpc:= )
	parquet? (
		>=app-arch/lz4-1.10
		dev-cpp/xsimd
		dev-libs/re2:=
	)
	pmdk? (
		>=dev-libs/pmdk-1.10.0:=
		sys-block/ndctl:=
	)
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
	uring? ( sys-libs/liburing:= )
	xfs? ( sys-fs/xfsprogs:= )
	zbd? ( sys-block/libzbd:= )
"
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
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pecan[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
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

PATCHES=(
	"${FILESDIR}/ceph-12.2.0-use-provided-cpu-flag-values.patch"
	"${FILESDIR}/ceph-17.2.1-no-virtualenvs.patch"
	"${FILESDIR}/ceph-14.2.0-dpdk-cflags.patch"
	"${FILESDIR}/ceph-16.2.0-rocksdb-cmake.patch"
	"${FILESDIR}/ceph-16.2.0-spdk-tinfo.patch"
	"${FILESDIR}/ceph-16.2.0-jaeger-system-boost.patch"
	"${FILESDIR}/ceph-17.2.0-pybind-boost-1.74.patch"
	"${FILESDIR}/ceph-17.2.0-findre2.patch"
	"${FILESDIR}/ceph-17.2.0-osd_class_dir.patch"
	# https://bugs.gentoo.org/866165
	"${FILESDIR}/ceph-17.2.5-suppress-cmake-warning.patch"
	# https://bugs.gentoo.org/868891
	"${FILESDIR}/ceph-18.2.0-cyclic-deps.patch"
	# https://bugs.gentoo.org/907739
	"${FILESDIR}/ceph-18.2.0-cython3.patch"
	# https://bugs.gentoo.org/936889
	"${FILESDIR}/ceph-18.2.4-liburing.patch"
	"${FILESDIR}/ceph-18.2.4-spdk.patch"
	"${FILESDIR}/ceph-19.2.1-isa-l.patch"
	"${FILESDIR}/ceph-19.2.2-QATAPP-Fix-clang-16-compiling-issue.patch"
	"${FILESDIR}/ceph-19.2.2-add-option-to-build-agains-system-opentelemetry.patch"
	"${FILESDIR}/ceph-19.2.2-common-add-dependency-on-legacy-option-headers.patch"
	"${FILESDIR}/ceph-19.2.2-rbd-make-enums-statically-castable.patch"
	"${FILESDIR}/ceph-19.2.2-rgw-remove-FMT_STRING-to-fix-clang-20-build-failure.patch"
	# https://bugs.gentoo.org/960812
	"${FILESDIR}/ceph-19.2.2-silent-unused-variable-warning.patch"
	"${FILESDIR}/ceph-19.2.2-src-mgr-make-enum-statically-castable.patch"
	"${FILESDIR}/ceph-20.1.0-nvmeof.patch"
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
	python_setup
	lua_setup
	check-reqs_export_vars
	check-reqs_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if use system-boost; then
		if has_version '>=dev-libs/boost-1.88'; then
			eapply "${FILESDIR}/ceph-19.2.2-boost188.patch"
			eapply "${FILESDIR}/ceph-19.2.2-boost-linking.patch"
		fi
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

	sed -e "s:objdump -p:$(tc-getOBJDUMP) -p:" -i CMakeLists.txt || die

	# force lua version to use selected version
	local lua_version
	lua_version=$(ver_cut 1-2 $(lua_get_version))
	sed "s:find_package(Lua [0-9][.][0-9] REQUIRED):find_package(Lua ${lua_version} EXACT REQUIRED):" \
		-i src/CMakeLists.txt || die

	if use spdk; then
		# https://bugs.gentoo.org/871942
		sed -i 's/[#]ifndef HAVE_ARC4RANDOM/#if 0/' src/spdk/lib/iscsi/iscsi.c || die
		# unittests fail to build (??!?)
		sed -i -e 's/CONFIG_UNIT_TESTS=y/CONFIG_UNIT_TESTS=n/' src/spdk/CONFIG || die
	fi

	# remove tests that need root access
	rm src/test/cli/ceph-authtool/cap*.t || die

	if use parquet; then
		# hammer in newer version of parquet/arrow
		rm -r src/arrow/ || die
		mv "${WORKDIR}/apache-arrow-17.0.0" src/arrow || die
	fi

	# everyone forgot to link to boost_url
	sed -i -e 's~target_link_libraries(ceph-mds mds ${CMAKE_DL_LIBS} global-static ceph-common~target_link_libraries(ceph-mds mds ${CMAKE_DL_LIBS} global-static ceph-common boost_url~' src/CMakeLists.txt || die
	sed -i -e 's/target_link_libraries(journal cls_journal_client)/target_link_libraries(journal cls_journal_client boost_url)/' src/journal/CMakeLists.txt || die
	sed -i -e 's/${BLKID_LIBRARIES} ${CMAKE_DL_LIBS})/${BLKID_LIBRARIES} ${CMAKE_DL_LIBS} boost_url)/g' src/tools/cephfs/CMakeLists.txt || die
}

ceph_src_configure() {
	local mycmakeargs=(
		# Don't break installed bundled libraries (bug #942680)
		-DBUILD_SHARED_LIBS=OFF
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
		-DENABLE_SHARED:BOOL=ON
		-DALLOCATOR:STRING=$(usex tcmalloc 'tcmalloc' "$(usex jemalloc 'jemalloc' 'libc')")
		-DWITH_SYSTEM_PMDK:BOOL=$(usex pmdk 'YES' "$(usex rbd-rwl '')")
		-DWITH_SYSTEM_BOOST:BOOL=$(usex system-boost)
		-DWITH_SYSTEM_ROCKSDB:BOOL=ON
		-DWITH_SYSTEM_ZSTD:BOOL=ON
		-DWITH_RDMA:BOOL=$(usex rdma)
		-DWITH_SYSTEM_UTF8PROC:BOOL=ON
		-DCMAKE_INSTALL_DOCDIR:PATH="${EPREFIX}/usr/share/doc/${PN}-${PVR}"
		-DCMAKE_INSTALL_SYSCONFDIR:PATH="${EPREFIX}/etc"
		-DWITH_SYSTEM_FMT=ON
		-Wno-dev
		-DCEPHADM_BUNDLED_DEPENDENCIES=none
		-DWITH_NVMEOF_GATEWAY_MONITOR_CLIENT:BOOL=$(usex nvmeof)
	)

	# this breaks when re-configuring for python impl
	if [[ ${EBUILD_PHASE} == configure ]]; then
		mycmakeargs+=(
			-DWITH_JAEGER:BOOL=$(usex jaeger)
			-DWITH_RADOSGW_SELECT_PARQUET:BOOL=$(usex parquet)
		)
		if use jaeger; then
			mycmakeargs+=( -DWITH_SYSTEM_OPENTELEMETRY:BOOL=ON )
		fi
	else
		mycmakeargs+=(
			-DWITH_RADOSGW_SELECT_PARQUET:BOOL=OFF
			-DWITH_JAEGER:BOOL=OFF
			# don't want to warn about unused CLI when reconfiguring for python
			-DCMAKE_WARN_UNUSED_CLI:BOOL=OFF
		)
	fi

	# conditionally used cmake args
	use test && mycmakearts+=( -DWITH_SYSTEM_GTEST:BOOL=$(usex test) )
	use systemd && mycmakeargs+=( -DSYSTEMD_SYSTEM_UNIT_DIR:PATH=$(systemd_get_systemunitdir) )

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

	# https://bugs.gentoo.org/927066
	filter-lto

	# hopefully this will not be necessary in the next release
	use parquet && export ARROW_XSIMD_URL="file:///${DISTDIR}/ceph-xsimd-${PV}.tar.gz"

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
	export CMAKE_BUILD_PARALLEL_LEVEL=$(makeopts_jobs)
	cmake_build all

	# we have to do this here to prevent from building everything multiple times
	python_copy_sources
	python_foreach_impl python_compile
}

python_compile() {
	local CMAKE_USE_DIR="${S}"
	ceph_src_configure

	cmake_build src/pybind/CMakeFiles/cython_modules
	cmake_build cephadm
}

src_install() {
	python_foreach_impl python_install

	python_setup
	cmake_src_install

	python_optimize

	find "${ED}" -name '*.la' -type f -delete || die

	local bundled_init="${ED}/etc/init.d/ceph"
	[[ -f "${bundled_init}" ]] && {
		rm "${bundled_init}" || die
	}

	exeinto /usr/$(get_libdir)/ceph
	newexe "${BUILD_DIR}/bin/init-ceph" init-ceph

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/ceph.logrotate-r2 ${PN}

	keepdir /var/lib/${PN}{,/tmp} /var/log/ceph/stat /var/log/ceph/console

	fowners -R ceph:ceph /var/log/ceph

	newinitd "${FILESDIR}/rbdmap.initd-r1" rbdmap
	newinitd "${FILESDIR}/${PN}.initd-r14" ${PN}
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
	DESTDIR="${ED}" cmake_build src/pybind/install
	DESTDIR="${ED}" cmake_build src/cephadm/install

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
