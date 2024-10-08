# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 18 )
LLVM_OPTIONAL=1

PYTHON_COMPAT=( python3_{10..13} )

SCONS_MIN_VERSION="3.3.1"
CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit check-reqs flag-o-matic llvm-r1 multiprocessing pax-utils python-any-r1 scons-utils systemd toolchain-funcs

MY_PV=r${PV/_rc/-rc}
MY_P=mongo-${MY_PV}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.com"
SRC_URI="https://github.com/mongodb/mongo/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 SSPL-1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 -riscv"
CPU_FLAGS="cpu_flags_x86_avx"
IUSE="debug clang kerberos mongosh ssl +tools ${CPU_FLAGS}"

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
	>=sys-libs/zlib-1.2.12:=
	clang? (
		$(llvm_gen_dep "
			sys-devel/clang:\${LLVM_SLOT}
		")
	)
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
	')
"
PDEPEND="
	mongosh? ( app-admin/mongosh-bin )
	tools? ( >=app-admin/mongo-tools-100 )
"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.1-boost.patch"
	"${FILESDIR}/${PN}-5.0.29-gcc-11.patch"
	"${FILESDIR}/${PN}-5.0.2-fix-scons.patch"
	"${FILESDIR}/${PN}-5.0.2-no-compass.patch"
	"${FILESDIR}/${PN}-5.0.2-skip-no-exceptions.patch"
	"${FILESDIR}/${PN}-5.0.2-skip-reqs-check.patch"
	"${FILESDIR}/${PN}-5.0.2-boost-1.79.patch"
	"${FILESDIR}/${PN}-5.0.5-no-force-lld.patch"
	"${FILESDIR}/${PN}-4.4.10-boost-1.81.patch"
	"${FILESDIR}/${PN}-5.0.5-boost-1.81-extra.patch"
	"${FILESDIR}/${PN}-5.0.16-arm64-assert.patch"
	"${FILESDIR}/${PN}-4.4.29-no-enterprise.patch"
	"${FILESDIR}/${PN}-5.0.26-boost-1.85.patch"
	"${FILESDIR}/${PN}-5.0.26-boost-1.85-extra.patch"
	"${FILESDIR}/${PN}-5.0.29-gcc-15.patch"
)

python_check_deps() {
	python_has_version -b ">=dev-build/scons-3.1.1[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/cheetah3[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/psutil[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]"
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
		if ver_test "$REPLACING_VERSIONS" -lt 4.4; then
			ewarn "To upgrade from a version earlier than the 4.4-series, you must"
			ewarn "successively upgrade major releases until you have upgraded"
			ewarn "to 4.4-series. Then upgrade to 5.0 series."
		else
			ewarn "Be sure to set featureCompatibilityVersion to 4.4 before upgrading."
		fi
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
	if use clang; then
		llvm-r1_pkg_setup
		llvm_fix_tool_path CC CXX
	fi
}

src_prepare() {
	default

	# remove bundled libs
	rm -r src/third_party/{boost,pcre-*,snappy-*,yaml-cpp,zlib-*} || die

	# remove compass
	rm -r src/mongo/installer/compass || die
}

src_configure() {
	# https://github.com/mongodb/mongo/wiki/Build-Mongodb-From-Source
	# --use-system-icu fails tests
	# --use-system-tcmalloc is strongly NOT recommended:
	# for MONGO_GIT_HASH use GitOrigin-RevId from the commit of the tag
	scons_opts=(
		VERBOSE=1
		VARIANT_DIR=gentoo
		MONGO_VERSION="${PV}"
		MONGO_GIT_HASH="cd239f3b0c7796df9e576ae5a9efcf4e6960560c"

		--disable-warnings-as-errors
		--force-jobs # Reapply #906897, fix #935274
		--jobs="$(makeopts_jobs)"
		--use-system-boost
		--use-system-pcre
		--use-system-snappy
		--use-system-stemmer
		--use-system-yaml
		--use-system-zlib
		--use-system-zstd
	)

	local have_switched_compiler=
	if use clang && ! tc-is-clang; then
		# Force clang
		local version_clang=$(clang --version 2>/dev/null | grep -F -- 'clang version' | awk '{ print $3 }')
		[[ -n ${version_clang} ]] && version_clang=$(ver_cut 1 "${version_clang}")
		[[ -z ${version_clang} ]] && die "Failed to read clang version!"

		if tc-is-gcc; then
			have_switched_compiler=yes
		fi

		AR=llvm-ar
		CC=${CHOST}-clang-${version_clang}
		CXX=${CHOST}-clang++-${version_clang}

		scons_opts+=(
			AR="$(get_llvm_prefix)/bin/${AR}"
			CC="$(get_llvm_prefix)/bin/${CC}"
			CXX="$(get_llvm_prefix)/bin/${CXX}"
		)
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		have_switched_compiler=yes
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		scons_opts+=(
			AR="${AR}"
			CC="${CC}"
			CXX="${CXX}"
		)
	else
		scons_opts+=(
			AR="$(tc-getAR)"
			CC="$(tc-getCC)"
			CXX="$(tc-getCXX)"
		)
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
		# Because we switched active compiler we have to ensure
		# that no unsupported flags are set
		strip-unsupported-flags
		scons_opts+=(
			CCFLAGS="${CXXFLAGS}"
		)
	fi

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
	dodoc README docs/building.md

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
