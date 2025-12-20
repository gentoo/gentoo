# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CONFIG_CHECK="~ADVISE_SYSCALLS"
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="threads(+)"

inherit bash-completion-r1 check-reqs flag-o-matic linux-info ninja-utils pax-utils python-any-r1 toolchain-funcs xdg-utils

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT npm? ( Artistic-2 )"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nodejs/node"
	SLOT="0"
else
	SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz"
	SLOT="0/$(ver_cut 1)"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86 ~x64-macos"
	S="${WORKDIR}/node-v${PV}"
fi

IUSE="corepack cpu_flags_x86_sse2 debug doc +icu +inspector lto npm pax-kernel +snapshot +ssl +system-icu +system-ssl test"
REQUIRED_USE="inspector? ( icu ssl )
	npm? ( ssl )
	system-icu? ( icu )
	system-ssl? ( ssl )
	x86? ( cpu_flags_x86_sse2 )"

RESTRICT="!test? ( test )"

COMMON_DEPEND=">=app-arch/brotli-1.1.0:=
	dev-db/sqlite:3
	>=dev-libs/libuv-1.51.0:=
	>=dev-libs/simdjson-4.0.7:=
	>=net-dns/c-ares-1.34.5:=
	>=net-libs/nghttp2-1.66.0:=
	>=net-libs/nghttp3-1.7.0:=
	virtual/zlib:=
	corepack? ( !sys-apps/yarn )
	system-icu? ( >=dev-libs/icu-73:= )
	system-ssl? (
		>=net-libs/ngtcp2-1.11.0:=
		>=dev-libs/openssl-3.5.4:0=
	)
	!system-ssl? ( >=net-libs/ngtcp2-1.11.0:=[-gnutls] )
	|| (
		sys-devel/gcc:*
		llvm-runtimes/libatomic-stub
	)"
BDEPEND="${PYTHON_DEPS}
	app-alternatives/ninja
	sys-apps/coreutils
	virtual/pkgconfig
	test? ( net-misc/curl )
	pax-kernel? ( sys-apps/elfix )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

# These are measured on a loong machine with -ggdb on, and only checked
# if debugging flags are present in CFLAGS.
#
# The final link consumed a little more than 7GiB alone, so 8GiB is the lower
# limit for memory usage. Disk usage was 19.1GiB for the build directory and
# 1.2GiB for the installed image, so we leave some room for architectures with
# fatter binaries and set the disk requirement to 22GiB.
CHECKREQS_MEMORY="8G"
CHECKREQS_DISK_BUILD="22G"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			einfo "Checking for sufficient disk space and memory to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	tc-export AR CC CXX PKG_CONFIG
	export V=1
	export BUILDTYPE=Release

	# fix compilation on Darwin
	# https://code.google.com/p/gyp/issues/detail?id=260
	sed -i -e "/append('-arch/d" tools/gyp/pylib/gyp/xcode_emulation.py || die

	# proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" deps/npm/lib/npm.js || die

	# Avoid writing a depfile, not useful
	sed -i -e "/DEPFLAGS =/d" tools/gyp/pylib/gyp/generator/make.py || die

	sed -i -e "/'-O3'/d" common.gypi node.gypi || die

	# debug builds. change install path, remove optimisations and override buildtype
	if use debug; then
		sed -i -e "s|out/Release/|out/Debug/|g" tools/install.py || die
		BUILDTYPE=Debug
	fi

	# We need to disable mprotect on two files when it builds Bug 694100.
	use pax-kernel &&
		PATCHES+=( "${FILESDIR}"/${PN}-24.1.0-paxmarking.patch )

	default
}

src_configure() {
	xdg_environment_reset

	# LTO compiler flags are handled by configure.py itself
	filter-lto
	# The warnings are *so* noisy and make build.logs massive
	append-cxxflags $(test-flags-CXX -Wno-template-id-cdtor)
	# https://bugs.gentoo.org/931514
	use arm64 && append-flags $(test-flags-CXX -mbranch-protection=none)

	local myconf=(
		--ninja
		# ada is not packaged yet
		# https://github.com/ada-url/ada
		# --shared-ada
		--shared-brotli
		--shared-cares
		--shared-libuv
		--shared-nghttp2
		--shared-nghttp3
		--shared-ngtcp2
		--shared-simdjson
		# sindutf is not packaged yet
		# https://github.com/simdutf/simdutf
		# --shared-simdutf
		--shared-sqlite
		--shared-zlib
	)
	use debug && myconf+=( --debug )
	use lto && myconf+=( --enable-lto )
	if use system-icu; then
		myconf+=( --with-intl=system-icu )
	elif use icu; then
		myconf+=( --with-intl=full-icu )
	else
		myconf+=( --with-intl=none )
	fi
	use corepack || myconf+=( --without-corepack )
	use inspector || myconf+=( --without-inspector )
	use npm || myconf+=( --without-npm )
	use snapshot || myconf+=( --without-node-snapshot )
	if use ssl; then
		use system-ssl && myconf+=( --shared-openssl --openssl-use-def-ca-store )
	else
		myconf+=( --without-ssl )
	fi

	local myarch=""
	case "${ARCH}:${ABI}" in
		*:amd64) myarch="x64";;
		*:arm) myarch="arm";;
		*:arm64) myarch="arm64";;
		loong:lp64*) myarch="loong64";;
		riscv:lp64*) myarch="riscv64";;
		*:ppc64) myarch="ppc64";;
		*:x32) myarch="x32";;
		*:x86) myarch="ia32";;
		*) myarch="${ABI}";;
	esac

	GYP_DEFINES="linux_use_gold_flags=0
		linux_use_bundled_binutils=0
		linux_use_bundled_gold=0" \
	"${EPYTHON}" configure.py \
		--prefix="${EPREFIX}"/usr \
		--dest-cpu=${myarch} \
		"${myconf[@]}" || die
}

src_compile() {
	eninja -C out/Release
}

src_install() {
	local LIBDIR="${ED}/usr/$(get_libdir)"
	default

	pax-mark -m "${ED}"/usr/bin/node

	# set up a symlink structure that node-gyp expects..
	dodir /usr/include/node/deps/{v8,uv}
	dosym . /usr/include/node/src
	for var in deps/{uv,v8}/include; do
		dosym ../.. /usr/include/node/${var}
	done

	if use doc; then
		docinto html
		dodoc -r "${S}"/doc/*
	fi

	if use npm; then
		keepdir /etc/npm
		echo "NPM_CONFIG_GLOBALCONFIG=${EPREFIX}/etc/npm/npmrc" > "${T}"/50npm
		doenvd "${T}"/50npm

		# Install bash completion for `npm`
		local tmp_npm_completion_file="$(TMPDIR="${T}" mktemp -t npm.XXXXXXXXXX)"
		"${ED}/usr/bin/npm" completion > "${tmp_npm_completion_file}"
		newbashcomp "${tmp_npm_completion_file}" npm

		# Move man pages
		doman "${LIBDIR}"/node_modules/npm/man/man{1,5,7}/*

		# Clean up
		rm -f "${LIBDIR}"/node_modules/npm/{.mailmap,.npmignore,Makefile}

		local find_exp="-or -name"
		local find_name=()
		for match in "AUTHORS*" "CHANGELOG*" "CONTRIBUT*" "README*" \
			".travis.yml" ".eslint*" ".wercker.yml" ".npmignore" \
			"*.bat" "*.cmd"; do
			find_name+=( ${find_exp} "${match}" )
		done

		# Remove various development and/or inappropriate files and
		# useless docs of dependend packages.
		find "${LIBDIR}"/node_modules \
			\( -type d -name examples \) -or \( -type f \( \
				-iname "LICEN?E*" \
				"${find_name[@]}" \
			\) \) -exec rm -rf "{}" \;
	fi

	use corepack &&
		"${D}"/usr/bin/corepack enable --install-directory "${D}"/usr/bin

	mv "${ED}"/usr/share/doc/node "${ED}"/usr/share/doc/${PF} || die
}

src_test() {
	local drop_tests=(
		test/parallel/test-dns.js
		test/parallel/test-dns-resolveany-bad-ancount.js
		test/parallel/test-dns-setserver-when-querying.js
		test/parallel/test-dotenv.js
		test/parallel/test-fs-mkdir.js
		test/parallel/test-fs-read-stream.js
		test/parallel/test-fs-utimes-y2K38.js
		test/parallel/test-fs-watch-recursive-add-file.js
		test/parallel/test-http2-client-set-priority.js
		test/parallel/test-http2-priority-event.js
		test/parallel/test-process-euid-egid.js
		test/parallel/test-process-get-builtin.mjs
		test/parallel/test-process-initgroups.js
		test/parallel/test-process-setgroups.js
		test/parallel/test-process-uid-gid.js
		test/parallel/test-release-npm.js
		test/parallel/test-socket-write-after-fin-error.js
		test/parallel/test-strace-openat-openssl.js
		test/sequential/test-tls-session-timeout.js
		test/sequential/test-util-debug.js
	)
	# https://bugs.gentoo.org/963649
	has_version '>=dev-libs/openssl-3.6' &&
		drop_tests+=(
			test/parallel/test-tls-ocsp-callback
		)
	use inspector ||
		drop_tests+=(
			test/parallel/test-inspector-emit-protocol-event.js
			test/parallel/test-inspector-network-arbitrary-data.js
			test/parallel/test-inspector-network-domain.js
			test/parallel/test-inspector-network-fetch.js
			test/parallel/test-inspector-network-http.js
			test/sequential/test-watch-mode.mjs
		)
	rm -f "${drop_tests[@]}" || die "disabling tests failed"

	out/${BUILDTYPE}/cctest || die
	"${EPYTHON}" tools/test.py --mode=${BUILDTYPE,,} --flaky-tests=dontcare -J message parallel sequential || die
}

pkg_postinst() {
	if use npm; then
		ewarn "remember to run: source /etc/profile if you plan to use nodejs"
		ewarn " in your current shell"
	fi
}
