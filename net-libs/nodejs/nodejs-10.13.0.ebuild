# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit bash-completion-r1 eutils flag-o-matic pax-utils python-single-r1 toolchain-funcs

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz"

LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x64-macos"
IUSE="cpu_flags_x86_sse2 debug doc icu inspector +npm +snapshot +ssl systemtap test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	inspector? ( icu ssl )
	npm? ( ssl )
"

RDEPEND="
	>=dev-libs/libuv-1.23.2:=
	>=net-dns/c-ares-1.14.0
	>=net-libs/http-parser-2.8.0:=
	>=net-libs/nghttp2-1.34.0
	sys-libs/zlib
	icu? ( >=dev-libs/icu-62.1:= )
	ssl? ( =dev-libs/openssl-1.1.0*:0=[-bindist] )
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	systemtap? ( dev-util/systemtap )
	test? ( net-misc/curl )
"
S="${WORKDIR}/node-v${PV}"
PATCHES=(
	"${FILESDIR}"/${PN}-10.3.0-global-npm-config.patch
)

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."

	( [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11 ) && \
		die "Your compiler doesn't support C++11. Use GCC 4.8, Clang 3.3 or newer."
}

src_prepare() {
	tc-export CC CXX PKG_CONFIG
	export V=1
	export BUILDTYPE=Release

	# fix compilation on Darwin
	# https://code.google.com/p/gyp/issues/detail?id=260
	sed -i -e "/append('-arch/d" tools/gyp/pylib/gyp/xcode_emulation.py || die

	# make sure we use python2.* while using gyp
	sed -i -e "s/python/${EPYTHON}/" deps/npm/node_modules/node-gyp/gyp/gyp || die
	sed -i -e "s/|| 'python2'/|| '${EPYTHON}'/" deps/npm/node_modules/node-gyp/lib/configure.js || die

	# less verbose install output (stating the same as portage, basically)
	sed -i -e "/print/d" tools/install.py || die

	# proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" deps/npm/lib/npm.js || die

	# Avoid writing a depfile, not useful
	sed -i -e "/DEPFLAGS =/d" tools/gyp/pylib/gyp/generator/make.py || die

	sed -i -e "/'-O3'/d" common.gypi deps/v8/gypfiles/toolchain.gypi || die

	# Avoid a test that I've only been able to reproduce from emerge. It doesnt
	# seem sandbox related either (invoking it from a sandbox works fine).
	# The issue is that no stdin handle is openened when asked for one.
	# It doesn't really belong upstream , so it'll just be removed until someone
	# with more gentoo-knowledge than me (jbergstroem) figures it out.
	rm test/parallel/test-stdout-close-unref.js || die

	# debug builds. change install path, remove optimisations and override buildtype
	if use debug; then
		sed -i -e "s|out/Release/|out/Debug/|g" tools/install.py || die
		BUILDTYPE=Debug
	fi

	default
}

src_configure() {
	local myconf=( --shared-cares --shared-http-parser --shared-libuv --shared-nghttp2 --shared-zlib )
	use debug && myconf+=( --debug )
	use icu && myconf+=( --with-intl=system-icu ) || myconf+=( --with-intl=none )
	use inspector || myconf+=( --without-inspector )
	use npm || myconf+=( --without-npm )
	use snapshot && myconf+=( --with-snapshot )
	use ssl && myconf+=( --shared-openssl ) || myconf+=( --without-ssl )

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
	"${PYTHON}" configure \
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
	emake install DESTDIR="${D}"
	pax-mark -m "${ED}"usr/bin/node

	# set up a symlink structure that node-gyp expects..
	dodir /usr/include/node/deps/{v8,uv}
	dosym . /usr/include/node/src
	for var in deps/{uv,v8}/include; do
		dosym ../.. /usr/include/node/${var}
	done

	if use doc; then
		# Patch docs to make them offline readable
		for i in `grep -rl 'fonts.googleapis.com' "${S}"/out/doc/api/*`; do
			sed -i '/fonts.googleapis.com/ d' $i;
		done
		# Install docs
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
		local tmp_npm_completion_file="$(emktemp)"
		"${ED}/usr/bin/npm" completion > "${tmp_npm_completion_file}"
		newbashcomp "${tmp_npm_completion_file}" npm
		sed -i -e "s|'${ED}/etc'|'/etc'|g" "${ED}/${npm_config}" || die

		# Move man pages
		doman "${LIBDIR}"/node_modules/npm/man/man{1,5,7}/*

		# Clean up
		rm "${LIBDIR}"/node_modules/npm/{.mailmap,.npmignore,Makefile} || die
		rm -rf "${LIBDIR}"/node_modules/npm/{doc,html,man} || die

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

	mv "${D}"/usr/share/doc/node "${D}"/usr/share/doc/${PF} || die
}

src_test() {
	out/${BUILDTYPE}/cctest || die
	"${PYTHON}" tools/test.py --mode=${BUILDTYPE,,} -J message parallel sequential || die
}

pkg_postinst() {
	einfo "The global npm config lives in /etc/npm. This deviates slightly"
	einfo "from upstream which otherwise would have it live in /usr/etc/."
	einfo ""
	einfo "Protip: When using node-gyp to install native modules, you can"
	einfo "avoid having to download extras by doing the following:"
	einfo "$ node-gyp --nodedir /usr/include/node <command>"
}
