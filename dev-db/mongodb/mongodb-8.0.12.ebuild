# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

SCONS_MIN_VERSION="3.3.1"
CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit check-reqs eapi9-ver flag-o-matic multiprocessing pax-utils python-any-r1 scons-utils systemd toolchain-funcs

MY_PV=r${PV/_rc/-rc}
MY_P=mongo-${MY_PV}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.com"
SRC_URI="https://github.com/mongodb/mongo/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-8.0.8-patches.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 SSPL-1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 -riscv"
CPU_FLAGS="cpu_flags_x86_avx"
IUSE="debug kerberos mongosh ssl +tools ${CPU_FLAGS}"

# https://github.com/mongodb/mongo/wiki/Test-The-Mongodb-Server
# resmoke needs python packages not yet present in Gentoo
RESTRICT="test"

RDEPEND="acct-group/mongodb
	acct-user/mongodb
	>=app-arch/snappy-1.1.7:=
	app-arch/zstd:=
	>=dev-cpp/yaml-cpp-0.6.2:=
	dev-libs/boost:=[nls]
	>=dev-libs/libpcre-8.42[cxx]
	dev-libs/snowball-stemmer:=
	net-misc/curl
	>=virtual/zlib-1.2.12:=
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )
	ssl? (
		>=dev-libs/openssl-1.0.1g:0=
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	debug? ( dev-debug/valgrind )"
BDEPEND="
	$(python_gen_any_dep '
		>=dev-build/scons-3.1.1[${PYTHON_USEDEP}]
		dev-python/cheetah3[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/gitpython[${PYTHON_USEDEP}]
		dev-python/poetry[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/tenacity[${PYTHON_USEDEP}]
	')
"
PDEPEND="
	mongosh? ( app-admin/mongosh-bin )
	tools? ( >=app-admin/mongo-tools-100 )
"

PATCHES=(
	"${WORKDIR}/mongodb-8.0.8-patches/mongodb-4.4.29-no-enterprise.patch"
	"${WORKDIR}/mongodb-8.0.8-patches/${PN}-5.0.2-no-compass.patch"
	"${WORKDIR}/mongodb-8.0.8-patches/${PN}-8.0.6-skip-reqs-check.patch"
	"${WORKDIR}/mongodb-8.0.8-patches/${PN}-8.0.6-fixes-for-boost-1.85.patch"
	"${WORKDIR}/mongodb-8.0.8-patches/${PN}-8.0.4-scons.patch"
	"${WORKDIR}/mongodb-8.0.8-patches/${PN}-8.0.6-use-tenacity.patch"
	"${FILESDIR}/${PN}-8.0.8-sconstruct.patch"
	"${FILESDIR}/${PN}-8.0.8-fix-compile-error-due-to-deleted-constructor.patch"
	"${FILESDIR}/boost_issue_402.patch"
	"${FILESDIR}/${PN}-8.0.12-sconstruct.patch"
	# removed in boost-1.89.0, unnecessary earlier
	"${FILESDIR}/${PN}-8.0.12-boost-system.patch"
)

python_check_deps() {
	python_has_version -b ">=dev-build/scons-3.1.1[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/cheetah3[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/psutil[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/distro[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/gitpython[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/poetry[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/pymongo[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/tenacity[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	# Bug 809692 + 890294
	if use amd64 && ! use cpu_flags_x86_avx; then
		ewarn "MongoDB 5.0 requires use of the AVX instruction set."
		ewarn "This ebuild will use --experimental-optimization=-sandybridge which"
		ewarn "will result in an experimental build of MongoDB as per upstream."
		ewarn "https://docs.mongodb.com/v5.0/administration/production-notes/"
	fi

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		if ver_replacing -lt 4.4; then
			ewarn "To upgrade from a version earlier than the 4.4-series, you must"
			ewarn "successively upgrade major releases until you have upgraded"
			ewarn "to 4.4-series. Then upgrade to 5.0 series."
		else
			ewarn "Be sure to set featureCompatibilityVersion to 7.0 before upgrading."
		fi
	fi
}

src_prepare() {
	default
	# remove bundled libs
	rm -r src/third_party/{boost,snappy,yaml-cpp} || die

	# remove compass
	rm -r src/mongo/installer/compass || die
}

src_configure() {
	# https://github.com/mongodb/mongo/wiki/Build-Mongodb-From-Source
	# bugs #954813 and #942551
	filter-lto

	# https://github.com/mongodb/mongo/blob/v8.0/docs/building.md
	# --use-system-icu fails tests
	# --use-system-tcmalloc is strongly NOT recommended:
	# for MONGO_GIT_HASH use GitOrigin-RevId from the commit of the tag
	scons_opts=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		CCFLAGS="${CXXFLAGS}"

		VERBOSE=1
		VARIANT_DIR=gentoo
		MONGO_VERSION="${PV}"
		MONGO_GIT_HASH="b60fc6875b5fb4b63cc0dbbd8dda0d6d6277921a"
		--disable-warnings-as-errors
		--force-jobs # Reapply #906897, fix #935274
		--jobs="$(makeopts_jobs)"
		--use-system-boost
		--use-system-snappy
		--use-system-stemmer
		--use-system-yaml
		--use-system-zlib
		--use-system-zstd
	)

	use arm64 && scons_opts+=( --use-hardware-crc32=off ) # Bug 701300
	use amd64 && scons_opts+=( --experimental-optimization=-sandybridge ) # Bug 890294
	use debug && scons_opts+=( --dbg=on )
	use kerberos && scons_opts+=( --use-sasl-client )

	scons_opts+=( --ssl=$(usex ssl on off) )

	# Needed to avoid forcing FORTIFY_SOURCE
	# Gentoo's toolchain applies these anyway
	scons_opts+=( --runtime-hardening=off )

	# gold is an option here but we don't really do that anymore
	if tc-ld-is-lld; then
		 scons_opts+=( --linker=lld )
	else
		 scons_opts+=( --linker=bfd )
	fi

	# respect mongoDB upstream's basic recommendations
	# see bug #536688 and #526114
	if ! use debug; then
		filter-flags '-m*'
		filter-flags '-O?'
	fi

	default
}

src_compile() {
	PREFIX="${EPREFIX}/usr" ./buildscripts/scons.py "${scons_opts[@]}" install-devcore || die
}

src_install() {
	dobin build/install/bin/{mongo,mongod,mongos}

	doman debian/mongo*.1
	dodoc docs/building.md

	newinitd "${FILESDIR}/${PN}.initd-r3" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r3" ${PN}
	newinitd "${FILESDIR}/mongos.initd-r3" mongos
	newconfd "${FILESDIR}/mongos.confd-r3" mongos

	insinto /etc
	newins "${FILESDIR}/${PN}.conf-r3" ${PN}.conf
	newins "${FILESDIR}/mongos.conf-r2" mongos.conf

	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# see bug #526114
	pax-mark emr "${ED}"/usr/bin/{mongo,mongod,mongos}

	diropts -m0750 -o mongodb -g mongodb
	keepdir /var/log/${PN}
}

pkg_postinst() {
	ewarn "Make sure to read the release notes and follow the upgrade process:"
	ewarn "  https://docs.mongodb.com/manual/release-notes/$(ver_cut 1-2)/"
	ewarn "  https://docs.mongodb.com/manual/release-notes/$(ver_cut 1-2)/#upgrade-procedures"
}
