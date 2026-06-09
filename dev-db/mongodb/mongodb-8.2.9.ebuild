# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit edo check-reqs eapi9-ver flag-o-matic multiprocessing pax-utils python-any-r1 systemd toolchain-funcs

BAZEL_VER="7.5.0-mongo_9ea3a8ad9f"
BAZEL_BASE_URL="https://mdb-build-public.s3.amazonaws.com/bazel_binary_waterfall_builds/9ea3a8ad9ffc29090d93780658c3ec19e75d9f17"
BAZEL_BCR_HASH="1451bc41ab31a6908b7bd0056797b5ea273c9fd8"

MY_PV=r${PV/_rc/-rc}
MY_P=mongo-${MY_PV}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.com"
SRC_URI="
	https://github.com/mongodb/mongo/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.gh.tar.gz
	amd64? (
		${BAZEL_BASE_URL}/${BAZEL_VER}/bazel-${BAZEL_VER}-linux-x86_64
		https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_amd64
	)
	arm64? (
		${BAZEL_BASE_URL}/${BAZEL_VER}/bazel-${BAZEL_VER}-linux-arm64
		https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_arm64
	)
	https://github.com/bazelbuild/bazel-central-registry/archive/${BAZEL_BCR_HASH}.tar.gz
		-> ${PN}-bcr-${BAZEL_BCR_HASH}.tar.gz
	https://github.com/bats-core/bats-core/archive/v1.10.0.tar.gz
		-> bats-core-v1.10.0.tar.gz
	https://github.com/keith/buildifier-prebuilt/archive/refs/tags/6.4.0.tar.gz
		-> buildifier-prebuilt-6.4.0.tar.gz
	https://github.com/mongodb-forks/bazel_clang_tidy/archive/10c4bf70a8946789e3932f30e29dfba2dfb78e67.tar.gz
		-> bazel_clang_tidy-10c4bf70a8.tar.gz
	https://github.com/protocolbuffers/rules_ruby/archive/b7f3e9756f3c45527be27bc38840d5a1ba690436.zip
		-> rules_ruby-b7f3e9756f.zip
	https://github.com/protocolbuffers/utf8_range/archive/de0b4a8ff9b5d4c98108bdfe723291a33c52c54f.zip
		-> utf8_range-de0b4a8ff9.zip
	https://github.com/aspect-build/rules_js/releases/download/v2.1.3/rules_js-v2.1.3.tar.gz
	https://github.com/bazel-contrib/bazel-lib/releases/download/v2.13.0/bazel-lib-v2.13.0.tar.gz
	https://github.com/bazel-contrib/bazel_features/releases/download/v1.10.0/bazel_features-v1.10.0.tar.gz
	https://github.com/bazel-contrib/rules_nodejs/releases/download/v6.3.0/rules_nodejs-v6.3.0.tar.gz
	https://github.com/bazelbuild/apple_support/releases/download/1.17.1/apple_support.1.17.1.tar.gz
	https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz
	https://github.com/bazelbuild/platforms/releases/download/0.0.9/platforms-0.0.9.tar.gz
	https://github.com/bazelbuild/rules_cc/releases/download/0.0.9/rules_cc-0.0.9.tar.gz
	https://github.com/bazelbuild/rules_java/releases/download/7.6.5/rules_java-7.6.5.tar.gz
	https://github.com/bazelbuild/rules_license/releases/download/0.0.7/rules_license-0.0.7.tar.gz
	https://github.com/bazelbuild/rules_pkg/releases/download/1.0.1/rules_pkg-1.0.1.tar.gz
	https://github.com/bazelbuild/rules_proto/releases/download/6.0.0-rc1/rules_proto-6.0.0-rc1.tar.gz
	https://github.com/bazelbuild/rules_python/releases/download/0.35.0/rules_python-0.35.0.tar.gz
	https://github.com/theoremlp/rules_multitool/releases/download/v0.4.0/rules_multitool-0.4.0.tar.gz
	https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz
	https://registry.npmjs.org/eslint/-/eslint-9.19.0.tgz
	https://registry.npmjs.org/prettier/-/prettier-3.4.2.tgz
"

LICENSE="Apache-2.0 SSPL-1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 -riscv"
IUSE="debug mongosh ssl +tools"

# https://github.com/mongodb/mongo/wiki/Test-The-Mongodb-Server
# resmoke needs python packages not yet present in Gentoo
RESTRICT="test"

RDEPEND="acct-group/mongodb
	acct-user/mongodb
	net-misc/curl
	ssl? (
		>=dev-libs/openssl-3.0.0:0=
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/cheetah3[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	')
"
PDEPEND="
	mongosh? ( app-admin/mongosh-bin )
	tools? ( >=app-admin/mongo-tools-100 )
"

PATCHES=(
	"${FILESDIR}/${P}-disable-bazelisk-check.patch"
	"${FILESDIR}/${PN}-8.0.23-fix-compiler-names.patch"
	"${FILESDIR}/${PN}-8.0.23-override-distro.patch"
	"${FILESDIR}/${PN}-8.0.23-remove-mtune-march-cflags.patch"
	"${FILESDIR}/${P}-restore-syscall_h-includes.patch"
	"${FILESDIR}/${P}-use-system-python.patch"
)

python_check_deps() {
	python_has_version -b "dev-python/cheetah3[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/pymongo[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/packaging[${PYTHON_USEDEP}]"
}

ebazel() {
	debug-print-function ${FUNCNAME} "${@}"

	edo "${WORKDIR}"/bazel "$@"
}

src_unpack() {
	case $(tc-arch) in
		amd64)	  export EARCH=x86_64 ;;
		arm64)	  export EARCH=arm64 ;;
		*)		      die "architecture not supported: $(tc-arch)" ;;
	esac
	cp "${DISTDIR}/bazel-${BAZEL_VER}-linux-${EARCH}" bazel || die
	chmod +x bazel || die

	mkdir bazel_out || die

	unpack ${PN}-bcr-${BAZEL_BCR_HASH}.tar.gz
	ln -s bazel-central-registry-${BAZEL_BCR_HASH} bcr || die

	mkdir bazel_dist || die

	ln -s "${DISTDIR}"/* "${WORKDIR}/bazel_dist" || die
	ln -s "${DISTDIR}/bats-core-v1.10.0.tar.gz" "${WORKDIR}/bazel_dist/v1.10.0.tar.gz"
	ln -s "${DISTDIR}/buildifier-prebuilt-6.4.0.tar.gz" "${WORKDIR}/bazel_dist/6.4.0.tar.gz"
	ln -s "${DISTDIR}/bazel_clang_tidy-10c4bf70a8.tar.gz" "${WORKDIR}/bazel_dist/10c4bf70a8946789e3932f30e29dfba2dfb78e67.tar.gz"
	ln -s "${DISTDIR}/rules_ruby-b7f3e9756f.zip" "${WORKDIR}/bazel_dist/b7f3e9756f3c45527be27bc38840d5a1ba690436.zip"
	ln -s "${DISTDIR}/utf8_range-de0b4a8ff9.zip" "${WORKDIR}/bazel_dist/de0b4a8ff9b5d4c98108bdfe723291a33c52c54f.zip"

	unpack ${P}.gh.tar.gz
}

pkg_pretend() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		if ver_replacing -lt 7.0; then
			ewarn "To upgrade from a version earlier than the 7.0-series, you must"
			ewarn "successively upgrade major releases until you have upgraded"
			ewarn "to 7.0-series. Then upgrade to 8.0 series."
		else
			ewarn "Be sure to set featureCompatibilityVersion to 7.0 before upgrading."
		fi
	fi
}

src_prepare() {
	default

	# remove enterprise files from build
	sed -i '/enterprise/d' src/BUILD.bazel

	# remove compass
	rm -r src/mongo/installer/compass || die
}

src_configure() {
	# bug #954813
	filter-lto

	tc-export CC CXX AR
	export USE_NATIVE_TOOLCHAIN=1

	MYEBAZELARGS=(
		--compilation_mode=$(usex debug dbg opt)
		--distdir="${WORKDIR}/bazel_dist"
		--jobs=$(get_makeopts_jobs)
		--registry="file://${WORKDIR}/bcr"
		--repository_cache="${WORKDIR}/bazel_cache"
		--spawn_strategy=local
		--strip=$(usex debug never always)
		--subcommands
		--verbose_failures
		--noshow_progress
		--define=MONGO_VERSION="${PV}"
		--define=MONGO_DISTMOD=gentoo
		--repo_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=0
		--features=external_include_paths
		--host_features=external_include_paths
		--features=-per_object_debug_info
		--host_features=-per_object_debug_info
		--separate_debug=False
		--config=local
		--build_enterprise=False
		--disable_warnings_as_errors=True
		--release=True
		--dbg=$(usex debug True False)
		--opt=$(usex debug debug on)
		--debug_symbols=$(usex debug True False)
		--cxxopt=-std=c++20
		--host_cxxopt=-std=c++20
		--cxxopt=-w
		--host_cxxopt=-w
		--cxxopt=-Wno-error
		--host_cxxopt=-Wno-error
		--copt=-w
		--host_copt=-w
		--copt=-Wno-error
		--host_copt=-Wno-error
		--copt=-D_GNU_SOURCE
		--host_copt=-D_GNU_SOURCE
		--linkopt=-lresolv
		--linkopt=-Wl,-w
		--ssl=$(usex ssl True False)
	)

	if tc-ld-is-lld; then
		MYEBAZELARGS+=( --linker=lld )
	else
		MYEBAZELARGS+=(
			--linkopt=-fuse-ld=bfd
			--host_linkopt=-fuse-ld=bfd
			--nostart_end_lib
		)
	fi

	local cppflags
	for cppflags in ${CPPFLAGS}; do
		MYEBAZELARGS+=( --copt="${cppflags}" )
	done

	local cflags
	for cflags in ${CFLAGS}; do
		MYEBAZELARGS+=( --conlyopt="${cflags}" )
	done

	local cxxflags
	for cxxflags in ${CXXFLAGS}; do
		MYEBAZELARGS+=( --cxxopt="${cxxflags}" )
	done

	local ldflags
	for ldflags in ${LDFLAGS}; do
		MYEBAZELARGS+=( --linkopt="${ldflags}" )
	done

	# clean cache, just in case
	ebazel --output_base="${WORKDIR}/bazel_out" clean --expunge

	# this build --nobuild generates bazel_cache
	# this is useful to debug or make patch
	ebazel --output_base="${WORKDIR}/bazel_out" build --nobuild install-devcore "${MYEBAZELARGS[@]}"
}

src_compile() {
	ebazel --output_base="${WORKDIR}/bazel_out" build install-devcore "${MYEBAZELARGS[@]}" || die
}

src_install() {
	dobin bazel-bin/install/bin/{mongo,mongod,mongos}

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
