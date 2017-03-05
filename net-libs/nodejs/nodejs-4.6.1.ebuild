# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit flag-o-matic pax-utils python-single-r1 toolchain-funcs

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}.tar.xz"

LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86 ~x64-macos"
IUSE="cpu_flags_x86_sse2 debug icu +npm snapshot +ssl test"

RDEPEND="icu? ( >=dev-libs/icu-55:= )
	npm? ( ${PYTHON_DEPS} )
	>=net-libs/http-parser-2.5.2:=
	>=dev-libs/libuv-1.8.0:=
	>=dev-libs/openssl-1.0.2g:0=[-bindist]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	test? ( net-misc/curl )"

S="${WORKDIR}/node-v${PV}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_pretend() {
	(use x86 && ! use cpu_flags_x86_sse2) && \
		die "Your CPU doesn't support the required SSE2 instruction."

	( [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11 ) && \
		die "Your compiler doesn't support C++11. Use GCC 4.8, Clang 3.3 or newer."
}

src_prepare() {
	tc-export CC CXX PKG_CONFIG
	export V=1 # Verbose build
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
	local myconf+=( --shared-openssl --shared-libuv --shared-http-parser --shared-zlib )
	use npm || myconf+=( --without-npm )
	use icu && myconf+=( --with-intl=system-icu )
	use snapshot && myconf+=( --with-snapshot )
	use ssl || myconf+=( --without-ssl )
	use debug && myconf+=( --debug )

	case ${ABI} in
		amd64) myarch="x64";;
		arm) myarch="arm";;
		arm64) myarch="arm64";;
		ppc64) myarch="ppc64";;
		x32) myarch="x32";;
		x86) myarch="ia32";;
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
}

src_install() {
	local LIBDIR="${ED}/usr/$(get_libdir)"
	emake install DESTDIR="${ED}" PREFIX=/usr
	if use npm; then
		dodoc -r "${LIBDIR}"/node_modules/npm/html
		rm -rf "${LIBDIR}"/node_modules/npm/{doc,html} || die
		find "${LIBDIR}"/node_modules -type f -name "LICENSE*" -or -name "LICENCE*" -delete || die
	fi

	# set up a symlink structure that npm expects..
	dodir /usr/include/node/deps/{v8,uv}
	dosym . /usr/include/node/src
	for var in deps/{uv,v8}/include; do
		dosym ../.. /usr/include/node/${var}
	done

	pax-mark -m "${ED}"/usr/bin/node
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
