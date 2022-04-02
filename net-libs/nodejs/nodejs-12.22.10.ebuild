# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit bash-completion-r1 flag-o-matic pax-utils python-any-r1 toolchain-funcs xdg-utils

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nodejs/node"
	SLOT="0"
else
	SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz"
	SLOT="0/$(ver_cut 1)"
	KEYWORDS="~amd64 ~arm arm64 ppc64 -riscv ~x86 ~amd64-linux ~x64-macos"
	S="${WORKDIR}/node-v${PV}"
fi

IUSE="cpu_flags_x86_sse2 debug doc icu inspector lto +npm +snapshot +ssl +system-ssl systemtap test"
REQUIRED_USE="
	inspector? ( icu ssl )
	npm? ( ssl )
	system-ssl? ( ssl )
"

RESTRICT="!test? ( test )"

RDEPEND="
	>=app-arch/brotli-1.0.9:=
	>=dev-libs/libuv-1.39.0:=
	>=net-dns/c-ares-1.17.2:=
	>=net-libs/http-parser-2.9.3:=
	>=net-libs/nghttp2-1.40.0:=
	sys-libs/zlib
	icu? ( >=dev-libs/icu-64.2:= )
	system-ssl? (
		>=dev-libs/openssl-1.1.1:0=
		<dev-libs/openssl-3.0.0_beta1:0=
	)
"
BDEPEND="
	${PYTHON_DEPS}
	sys-apps/coreutils
	virtual/pkgconfig
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${P}-global-npm-config.patch
	"${FILESDIR}"/${PN}-12.20.1-fix_ppc64_crashes.patch
	"${FILESDIR}"/${PN}-12.22.1-jinja_collections_abc.patch
	"${FILESDIR}"/${PN}-12.22.1-uvwasi_shared_libuv.patch
	"${FILESDIR}"/${PN}-12.22.5-shared_c-ares_nameser_h.patch
	"${FILESDIR}"/${PN}-99999999-llhttp.patch
)

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."

	if [[ ${MERGE_TYPE} != "binary" ]]; then
		if use lto; then
			if tc-is-gcc; then
				if [[ $(gcc-major-version) -ge 11 ]]; then
					# Bug #787158
					die "LTO builds of ${PN} using gcc-11+ currently fail tests and produce runtime errors. Either switch to gcc-10 or unset USE=lto for this ebuild"
				fi
			else
				# configure.py will abort on this later if we do not
				die "${PN} only supports LTO for gcc"
			fi
		fi
	fi
}

src_prepare() {
	tc-export CC CXX PKG_CONFIG
	export V=1
	export BUILDTYPE=Release

	# fix compilation on Darwin
	# https://code.google.com/p/gyp/issues/detail?id=260
	sed -i -e "/append('-arch/d" tools/gyp/pylib/gyp/xcode_emulation.py || die

	# less verbose install output (stating the same as portage, basically)
	sed -i -e "/print/d" tools/install.py || die

	# proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" deps/npm/lib/npm.js || die

	# Avoid writing a depfile, not useful
	sed -i -e "/DEPFLAGS =/d" tools/gyp/pylib/gyp/generator/make.py || die

	sed -i -e "/'-O3'/d" common.gypi node.gypi || die

	# Known-to-fail test of a deprecated, legacy HTTP parser. Just don't bother.
	rm -f test/parallel/test-http-transfer-encoding-smuggling-legacy.js

	# debug builds. change install path, remove optimisations and override buildtype
	if use debug; then
		sed -i -e "s|out/Release/|out/Debug/|g" tools/install.py || die
		BUILDTYPE=Debug
	fi

	default
}

src_configure() {
	xdg_environment_reset

	# LTO compiler flags are handled by configure.py itself
	filter-flags '-flto*'

	local myconf=(
		--shared-brotli
		--shared-cares
		--shared-http-parser
		--shared-libuv
		--shared-nghttp2
		--shared-zlib
	)
	use debug && myconf+=( --debug )
	use lto && myconf+=( --enable-lto )
	use icu && myconf+=( --with-intl=system-icu ) || myconf+=( --with-intl=none )
	use inspector || myconf+=( --without-inspector )
	use npm || myconf+=( --without-npm )
	use snapshot || myconf+=( --without-node-snapshot )
	if use ssl; then
		use system-ssl && myconf+=( --shared-openssl --openssl-use-def-ca-store )
	else
		myconf+=( --without-ssl )
	fi

	local myarch=""
	case ${ABI} in
		amd64) myarch="x64";;
		arm) myarch="arm";;
		arm64) myarch="arm64";;
		ppc64) myarch="ppc64";;
		x32) myarch="x32";;
		x86) myarch="ia32";;
		*) myarch="${ABI}";;
	esac

	GYP_DEFINES="linux_use_gold_flags=0
		linux_use_bundled_binutils=0
		linux_use_bundled_gold=0" \
	"${EPYTHON}" configure.py \
		--prefix="${EPREFIX}"/usr \
		--dest-cpu=${myarch} \
		$(use_with systemtap dtrace) \
		"${myconf[@]}" || die
}

src_compile() {
	emake -C out mksnapshot
	pax-mark m "out/${BUILDTYPE}/mksnapshot"
	emake -C out
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
		dodir /etc/npm

		# Install bash completion for `npm`
		# We need to temporarily replace default config path since
		# npm otherwise tries to write outside of the sandbox
		local npm_config="usr/$(get_libdir)/node_modules/npm/lib/config/core.js"
		sed -i -e "s|'/etc'|'${ED}/etc'|g" "${ED}/${npm_config}" || die
		local tmp_npm_completion_file="$(TMPDIR="${T}" mktemp -t npm.XXXXXXXXXX)"
		"${ED}/usr/bin/npm" completion > "${tmp_npm_completion_file}"
		newbashcomp "${tmp_npm_completion_file}" npm
		sed -i -e "s|'${ED}/etc'|'/etc'|g" "${ED}/${npm_config}" || die

		# Move man pages
		doman "${LIBDIR}"/node_modules/npm/man/man{1,5,7}/*

		# Clean up
		rm -f "${LIBDIR}"/node_modules/npm/{.mailmap,.npmignore,Makefile}
		rm -rf "${LIBDIR}"/node_modules/npm/{doc,html,man}

		local find_exp="-or -name"
		local find_name=()
		for match in "AUTHORS*" "CHANGELOG*" "CONTRIBUT*" "README*" \
			".travis.yml" ".eslint*" ".wercker.yml" ".npmignore" \
			"*.md" "*.markdown" "*.bat" "*.cmd"; do
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

	mv "${ED}"/usr/share/doc/node "${ED}"/usr/share/doc/${PF} || die
}

src_test() {
	if has usersandbox ${FEATURES}; then
		rm -f "${S}"/test/parallel/test-fs-mkdir.js
		ewarn "You are emerging ${PN} with 'usersandbox' enabled. Excluding tests known to fail in this mode." \
			"For full test coverage, emerge =${CATEGORY}/${PF} with 'FEATURES=-usersandbox'."
	fi

	out/${BUILDTYPE}/cctest || die
	"${PYTHON}" tools/test.py --mode=${BUILDTYPE,,} --flaky-tests=dontcare -J message parallel sequential || die
}

pkg_postinst() {
	elog "The global npm config lives in /etc/npm. This deviates slightly"
	elog "from upstream which otherwise would have it live in /usr/etc/."
	elog ""
	elog "Protip: When using node-gyp to install native modules, you can"
	elog "avoid having to download extras by doing the following:"
	elog "$ node-gyp --nodedir /usr/include/node <command>"
}
