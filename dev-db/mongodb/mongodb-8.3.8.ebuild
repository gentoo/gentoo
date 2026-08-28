# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

CHECKREQS_DISK_BUILD="6200M"
CHECKREQS_DISK_USR="350M"
CHECKREQS_MEMORY="1024M"

inherit edo check-reqs eapi9-ver flag-o-matic multiprocessing pax-utils python-any-r1 systemd toolchain-funcs

BAZEL_VER="7.5.0-mongo_06d753863d"
BAZEL_BASE_URL="https://mdb-build-public.s3.amazonaws.com/bazel_binary_waterfall_builds/06d753863dde251110daef739d2c3e419782b881"
BAZEL_BCR_HASH="1451bc41ab31a6908b7bd0056797b5ea273c9fd8"

MY_PV=r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="https://www.mongodb.com"
SRC_URI="
	https://github.com/mongodb/mongo/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.gh.tar.gz
	amd64? (
		${BAZEL_BASE_URL}/${BAZEL_VER}/bazel-${BAZEL_VER}-linux-x86_64
		https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_amd64
		https://mdb-build-public.s3.us-east-1.amazonaws.com/gpg-binaries/SERVER-115285/gpg_bundle-x86_64.tar.gz
	)
	arm64? (
		${BAZEL_BASE_URL}/${BAZEL_VER}/bazel-${BAZEL_VER}-linux-arm64
		https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_arm64
		https://mdb-build-public.s3.us-east-1.amazonaws.com/gpg-binaries/SERVER-115285/gpg_bundle-aarch64.tar.gz
	)
	https://pgp.mongodb.com/mongot-extension.pub
	https://github.com/bazelbuild/bazel-central-registry/archive/${BAZEL_BCR_HASH}.tar.gz
		-> ${PN}-bcr-${BAZEL_BCR_HASH}.tar.gz
	https://github.com/bats-core/bats-core/archive/v1.10.0.tar.gz
		-> ${PN}-bats-core__v1.10.0.tar.gz
	https://github.com/bazel-contrib/rules_perl/archive/refs/tags/0.2.4.tar.gz
		-> ${PN}-rules_perl__0.2.4.tar.gz
	https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz
		-> ${PN}-rules_proto__5.3.0-21.7.tar.gz
	https://github.com/bufbuild/protoc-gen-validate/archive/refs/tags/v1.2.1.tar.gz
		-> ${PN}-protoc-gen-validate__v1.2.1.tar.gz
	https://github.com/cncf/xds/archive/555b57ec207be86f811fb0c04752db6f85e3d7e2.tar.gz
		-> ${PN}-xds__555b57ec207be86f811fb0c04752db6f85e3d7e2.tar.gz
	https://github.com/envoyproxy/data-plane-api/archive/4de3c74cf21a9958c1cf26d8993c55c6e0d28b49.tar.gz
		-> ${PN}-data-plane-api__4de3c74cf21a9958c1cf26d8993c55c6e0d28b49.tar.gz
	https://github.com/google/cel-spec/archive/refs/tags/v0.15.0.tar.gz
		-> ${PN}-cel-spec__v0.15.0.tar.gz
	https://github.com/googleapis/googleapis/archive/fe8ba054ad4f7eca946c2d14a63c3f07c0b586a0.tar.gz
		-> ${PN}-googleapis__fe8ba054ad4f7eca946c2d14a63c3f07c0b586a0.tar.gz
	https://github.com/keith/buildifier-prebuilt/archive/refs/tags/6.4.0.tar.gz
		-> ${PN}-buildifier-prebuilt__6.4.0.tar.gz
	https://github.com/mongodb-forks/bazel_clang_tidy/archive/refs/tags/v1.7.tar.gz
		-> ${PN}-bazel_clang_tidy__v1.7.tar.gz
	https://github.com/aspect-build/rules_js/releases/download/v2.1.3/rules_js-v2.1.3.tar.gz
	https://github.com/bazel-contrib/bazel-lib/releases/download/v2.13.0/bazel-lib-v2.13.0.tar.gz
	https://github.com/bazel-contrib/bazel_features/releases/download/v1.37.0/bazel_features-v1.37.0.tar.gz
	https://github.com/bazel-contrib/rules_foreign_cc/releases/download/0.15.1/rules_foreign_cc-0.15.1.tar.gz
	https://github.com/bazel-contrib/rules_nodejs/releases/download/v6.3.0/rules_nodejs-v6.3.0.tar.gz
	https://github.com/bazelbuild/apple_support/releases/download/1.24.1/apple_support.1.24.1.tar.gz
	https://github.com/bazelbuild/bazel-skylib/releases/download/1.9.0/bazel-skylib-1.9.0.tar.gz
	https://github.com/bazelbuild/platforms/releases/download/0.0.11/platforms-0.0.11.tar.gz
	https://github.com/bazelbuild/rules_apple/releases/download/3.16.0/rules_apple.3.16.0.tar.gz
	https://github.com/bazelbuild/rules_cc/releases/download/0.2.10/rules_cc-0.2.10.tar.gz
	https://github.com/bazelbuild/rules_go/releases/download/v0.50.1/rules_go-v0.50.1.zip
	https://github.com/bazelbuild/rules_java/releases/download/8.6.1/rules_java-8.6.1.tar.gz
	https://github.com/bazelbuild/rules_kotlin/releases/download/v1.9.6/rules_kotlin-v1.9.6.tar.gz
	https://github.com/bazelbuild/rules_license/releases/download/1.0.0/rules_license-1.0.0.tar.gz
	https://github.com/bazelbuild/rules_pkg/releases/download/1.2.0/rules_pkg-1.2.0.tar.gz
	https://github.com/bazelbuild/rules_proto/releases/download/7.1.0/rules_proto-7.1.0.tar.gz
	https://github.com/bazelbuild/rules_python/releases/download/1.8.5/rules_python-1.8.5.tar.gz
	https://github.com/bazelbuild/rules_shell/releases/download/v0.3.0/rules_shell-v0.3.0.tar.gz
	https://github.com/bazelbuild/rules_swift/releases/download/2.1.1/rules_swift.2.1.1.tar.gz
	https://github.com/theoremlp/rules_multitool/releases/download/v0.4.0/rules_multitool-0.4.0.tar.gz
	https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz
	https://registry.npmjs.org/eslint/-/eslint-9.19.0.tgz
	https://registry.npmjs.org/prettier/-/prettier-3.4.2.tgz
"
S="${WORKDIR}/mongo-${MY_PV}"

LICENSE="Apache-2.0 SSPL-1"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="debug ssl"

# https://github.com/mongodb/mongo/wiki/Test-The-Mongodb-Server
# resmoke needs python packages not yet present in Gentoo
RESTRICT="test"

RDEPEND="
	acct-group/mongodb
	acct-user/mongodb
	net-misc/curl
	ssl? ( >=dev-libs/openssl-3.0.0:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/asn1crypto[${PYTHON_USEDEP}]
		dev-python/cheetah3[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/ecdsa[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	')
	sys-apps/ripgrep
	dev-lang/perl
"

PATCHES=(
	"${FILESDIR}/${P}-add-missing-mongos-dependency.patch"
	"${FILESDIR}/${P}-disable-bazelisk-check.patch"
	"${FILESDIR}/${PN}-8.0.29-fix-compiler-names.patch"
	"${FILESDIR}/${PN}-8.0.29-fix-toolchain-environment.patch"
	"${FILESDIR}/${P}-fix-grpc-build.patch"
	"${FILESDIR}/${P}-override-distro.patch"
	"${FILESDIR}/${P}-remove-mtune-march-cflags.patch"
	"${FILESDIR}/${P}-restore-syscall_h-includes.patch"
	"${FILESDIR}/${P}-use-system-python.patch"
)

python_check_deps() {
	python_has_version -b "dev-python/asn1crypto[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/cheetah3[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/cryptography[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/ecdsa[${PYTHON_USEDEP}]" &&
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
		amd64)	export EARCH=x86_64 ;;
		arm64)	export EARCH=arm64 ;;
		*)	die "architecture not supported: $(tc-arch)" ;;
	esac

	cp "${DISTDIR}/bazel-${BAZEL_VER}-linux-${EARCH}" bazel || die
	chmod +x bazel || die

	mkdir bazel_out || die

	unpack ${PN}-bcr-${BAZEL_BCR_HASH}.tar.gz
	ln -s bazel-central-registry-${BAZEL_BCR_HASH} bcr || die

	mkdir bazel_dist || die
	pushd "${DISTDIR}" >/dev/null || die
	local dep
	for dep in *; do
		ln -sfT "${DISTDIR}/${dep}" "${WORKDIR}/bazel_dist/${dep#*__}" || die
	done
	popd >/dev/null || die

	unpack ${P}.gh.tar.gz
}

pkg_pretend() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		if ver_replacing -lt 8.0; then
			ewarn "To upgrade from a version earlier than 8.0, you must"
			ewarn "successively upgrade major releases until you have upgraded"
			ewarn "to 8.0. Then upgrade to 8.3."
		elif ver_replacing -lt 8.3; then
			ewarn "Be sure to set featureCompatibilityVersion to $(ver_cut 1-2 ${REPLACING_VERSIONS}) before upgrading."
		fi
	fi
}

src_prepare() {
	default

	# remove compass
	rm -r src/mongo/installer/compass || die

	# remove all references to poetry and fix python interpreter references
	find "${S}" -name '*.b*z*l' -exec perl -0 -p -i \
		-e 's#load\("\@poetry//.+?"\)\s*##gm;' \
		-e 's#dependency\(.*?\),?##gs;' \
		-e 's#python\.files#depset()#g;' \
		-e 's#python\.interpreter\.path#python.interpreter_path#g;' {} \; || die

	# replace placeholder with actual python executable
	sed -i "s#@PYTHON@#${PYTHON}#" "${S}/MODULE.bazel" || die

	# run auto_header.py
	edob ${PYTHON} "${FILESDIR}"/auto_header.py "${S}"
}

src_configure() {
	# bug #954813
	filter-lto

	tc-export CC CXX AR

	MYEBAZELARGS=(
		--config=public-release-local
		--compiler=$(tc-getCC)
		--host_compiler=$(tc-getBUILD_CC)
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
		--build_enterprise=False
		--disable_warnings_as_errors=True
		--dbg=$(usex debug True False)
		--debug_symbols=$(usex debug True False)
		--ssl=$(usex ssl True False)
	)

	# several .cpp files attempt to compile with -std=c++17 and fail
	append-cxxflags -std=c++20

	# these defines are expected by build system and were placed inside
	# the mongo_linux toolchain that we bypassed
	append-cppflags -D_XOPEN_SOURCE=700 -D_GNU_SOURCE

	# -Werror is injected in a few places
	append-flags -Wno-error

	# strict aliasing is broken
	append-flags -fno-strict-aliasing

	# missing library reference in link stage
	append-libs -lresolv

	# the only valid options for --linker are auto, lld, and mold
	# auto is default and will set linker to lld on linux
	# it explicitly passes -fuse-ld and there is no option
	# to bypass this
	if tc-ld-is-mold; then
		MYEBAZELARGS+=( --linker=mold )
	elif tc-ld-is-gold; then
		append-ldflags -fuse-ld=gold
		BUILD_LDFLAGS="${BUILD_LDFLAGS} -fuse-ld=gold"
	elif tc-ld-is-bfd; then
		append-ldflags -fuse-ld=bfd
		BUILD_LDFLAGS="${BUILD_LDFLAGS} -fuse-ld=bfd"
		# start-lib / end-lib not supported by bfd
		MYEBAZELARGS+=( --nostart_end_lib )
	fi

	# .bazelrc unconditionally sets compiler-type to clang
	if tc-is-gcc; then
		MYEBAZELARGS+=( --compiler_type=gcc )
	fi

	local flags

	for flags in ${CPPFLAGS}; do
		MYEBAZELARGS+=( --copt="${flags}" )
	done

	for flags in ${CFLAGS}; do
		MYEBAZELARGS+=( --conlyopt="${flags}" )
	done

	for flags in ${CXXFLAGS}; do
		MYEBAZELARGS+=( --cxxopt="${flags}" )
	done

	for flags in ${LDFLAGS} ${LIBS}; do
		MYEBAZELARGS+=( --linkopt="${flags}" )
	done

	for flags in ${BUILD_CPPFLAGS}; do
		MYEBAZELARGS+=( --host_copt="${flags}" )
	done

	for flags in ${BUILD_CFLAGS}; do
		MYEBAZELARGS+=( --host_conlyopt="${flags}" )
	done

	for flags in ${BUILD_CXXFLAGS}; do
		MYEBAZELARGS+=( --host_cxxopt="${flags}" )
	done

	for flags in ${BUILD_LDFLAGS}; do
		MYEBAZELARGS+=( --host_linkopt="${flags}" )
	done

	# clean cache, just in case
	ebazel --output_base="${WORKDIR}/bazel_out" clean --expunge

	# this build --nobuild generates bazel_cache
	# this is useful to debug or make patch
	ebazel --output_base="${WORKDIR}/bazel_out" build --nobuild install-devcore "${MYEBAZELARGS[@]}"
}

src_compile() {
	ebazel --output_base="${WORKDIR}/bazel_out" build install-devcore "${MYEBAZELARGS[@]}"
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
	ewarn
	ewarn "app-admin/mongosh-bin and app-admin/mongo-tools are no longer pulled in by USE flags."
	ewarn "You will need to install them separately if you want to use them."
}
