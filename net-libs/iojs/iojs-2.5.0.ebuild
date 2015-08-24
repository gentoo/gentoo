# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

MY_PV="v${PV}"
MY_P="${PN}-${MY_PV}"

inherit flag-o-matic pax-utils python-single-r1 toolchain-funcs

DESCRIPTION="An npm compatible platform originally based on node.js"
HOMEPAGE="http://iojs.org/"
SRC_URI="http://iojs.org/dist/${MY_PV}/${MY_P}.tar.xz"

LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="debug icu +npm snapshot +ssl"

RDEPEND="icu? ( dev-libs/icu )
	${PYTHON_DEPS}
	>=net-libs/http-parser-2.5
	>=dev-libs/libuv-1.6.1
	>=dev-libs/openssl-1.0.2d[-bindist]"
DEPEND="${RDEPEND}
	!!net-libs/nodejs"
S="${WORKDIR}/${MY_P}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_pretend() {
	if ! test-flag-CXX -std=c++11 ; then
		die "Your compiler doesn't support C++11. Use GCC 4.8, Clang 3.3 or newer."
	fi
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
		x86) myarch="ia32";;
		amd64) myarch="x64";;
		x32) myarch="x32";;
		arm) myarch="arm";;
		arm64) myarch="arm64";;
		*) die "Unrecognized ARCH ${ARCH}";;
	esac

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
	use npm && dodoc -r "${LIBDIR}"/node_modules/npm/html
	rm -rf "${LIBDIR}"/node_modules/npm/{doc,html} || die
	find "${LIBDIR}"/node_modules -type f -name "LICENSE*" -or -name "LICENCE*" -delete || die

	# set up a symlink structure that npm expects..
	dodir /usr/include/node/deps/{v8,uv}
	dosym . /usr/include/node/src
	for var in deps/{uv,v8}/include; do
		dosym ../.. /usr/include/node/${var}
	done

	pax-mark -m "${ED}"/usr/bin/iojs
}

src_test() {
	out/${BUILDTYPE}/cctest || die
	declare -xl TESTTYPE="${BUILDTYPE}"
	"${PYTHON}" tools/test.py --mode=${TESTTYPE} -J message parallel sequential || die
}

pkg_postinst() {
	einfo "When using node-gyp to install native modules, you can avoid"
	einfo "having to download the full tarball by doing the following:"
	einfo ""
	einfo "node-gyp --nodedir /usr/include/node <command>"
}