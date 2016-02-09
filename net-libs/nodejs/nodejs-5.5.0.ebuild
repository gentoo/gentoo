# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit bash-completion-r1 eutils flag-o-matic pax-utils python-single-r1 toolchain-funcs

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz"

LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="cpu_flags_x86_sse2 debug doc icu +npm +snapshot +ssl test"

RDEPEND="icu? ( >=dev-libs/icu-56:= )
	${PYTHON_DEPS}
	>=net-libs/http-parser-2.6:=
	>=dev-libs/libuv-1.8.0:=
	>=dev-libs/openssl-1.0.2e:0=[-bindist]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	!!net-libs/iojs
	test? ( net-misc/curl )"

S="${WORKDIR}/node-v${PV}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."

	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if ! test-flag-CXX -std=c++11 ; then
			die "Your compiler doesn't support C++11. Use GCC 4.8, Clang 3.3 or newer."
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

	# make sure we use python2.* while using gyp
	sed -i -e "s/python/${EPYTHON}/" deps/npm/node_modules/node-gyp/gyp/gyp || die
	sed -i -e "s/|| 'python'/|| '${EPYTHON}'/" deps/npm/node_modules/node-gyp/lib/configure.js || die

	# less verbose install output (stating the same as portage, basically)
	sed -i -e "/print/d" tools/install.py || die

	# proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" lib/module.js || die
	sed -i -e "s|\"lib\"|\"${LIBDIR}\"|" deps/npm/lib/npm.js || die

	# Avoid writing a depfile, not useful
	sed -i -e "/DEPFLAGS =/d" tools/gyp/pylib/gyp/generator/make.py || die

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

	epatch_user
}

src_configure() {
	local myarch=""
	local myconf=( --shared-openssl --shared-libuv --shared-http-parser --shared-zlib )
	use npm || myconf+=( --without-npm )
	use icu && myconf+=( --with-intl=system-icu )
	use snapshot && myconf+=( --with-snapshot )
	use ssl || myconf+=( --without-ssl )
	use debug && myconf+=( --debug )

	case ${ABI} in
		x86) myarch="ia32";;
		amd64) myarch="x64";;
		x32) myarch="x32";;
		arm) myarch="arm";;
		arm64) myarch="arm64";;
		*) die "Unrecognized ARCH ${ARCH}";;
	esac

	GYP_DEFINES="linux_use_gold_flags=0
		linux_use_bundled_binutils=0
		linux_use_bundled_gold=0" \
	"${PYTHON}" configure \
		--prefix="${EPREFIX}"/usr \
		--dest-cpu=${myarch} \
		--without-dtrace \
		"${myconf[@]}" || die
}

src_compile() {
	emake -C out mksnapshot
	pax-mark m "out/${BUILDTYPE}/mksnapshot"
	emake -C out

	use doc && emake doc
}

src_install() {
	local LIBDIR="${ED}/usr/$(get_libdir)"
	make install DESTDIR="${ED}" PREFIX=/usr
	pax-mark -m "${ED}"usr/bin/node

	# set up a symlink structure that npm expects..
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
		# Install docs!
		dohtml -r "${S}"/out/doc/api/*
	fi

	if use npm; then
		# Install bash completion for `npm`
		local tmp_npm_completion_file="$(emktemp)"
		"${ED}/usr/bin/npm" completion > "${tmp_npm_completion_file}"
		newbashcomp "${tmp_npm_completion_file}" npm
		rm "${LIBDIR}"/node_modules/npm/lib/utils/completion.sh

		# Move man pages
		doman "${LIBDIR}"/node_modules/npm/man/man{1,5,7}/*

		# Clean up
		rm "${LIBDIR}"/node_modules/npm/{.mailmap,.npmignore,Makefile} || die
		rm -rf "${LIBDIR}"/node_modules/npm/{doc,html,man} || die

		local temp_name=("'AUTHORS*'" "'CHANGELOG*'" "'CONTRIBUT*'" \
			"'README*'" "'.travis.yml'" "'.eslint*'" "'.wercker.yml'" \
			"'.npmignore'" "'*.md'" "'*.markdown'" "'*.bat'" "'*.cmd'")
		local find_exp="-or -name"
		local find_name=( "${temp_name[@]/%/ ${find_exp}}" )
		# drop last "-or -name"
		find_name[-1]="${find_name[-1]%${find_exp}}"
		local find_iname="-iname 'LICEN?E*' ${find_exp}"

		# Remove various development and/or inappropriate files and
		# useless docs of dependend packages.
		find "${LIBDIR}"/node_modules \
			\( -type d -name examples \) -or \( -type f \( \
				${find_iname} ${find_name[@]} \
			\) \)
		eend $?
	fi
}

src_test() {
	out/${BUILDTYPE}/cctest || die
	"${PYTHON}" tools/test.py --mode=${BUILDTYPE,,} -J message parallel sequential || die
}

pkg_postinst() {
	einfo "When using node-gyp to install native modules, you can avoid"
	einfo "having to download the full tarball by doing the following:"
	einfo ""
	einfo "node-gyp --nodedir /usr/include/node <command>"
}
