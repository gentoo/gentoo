# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/iojs/iojs-1.6.3.ebuild,v 1.1 2015/04/02 06:48:25 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

MY_PV="v${PV}"
MY_P="${PN}-${MY_PV}"

inherit python-any-r1 pax-utils toolchain-funcs flag-o-matic

DESCRIPTION="An npm compatible platform originally based on node.js"
HOMEPAGE="http://iojs.org/"
SRC_URI="http://iojs.org/dist/${MY_PV}/${MY_P}.tar.xz"

LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="icu +npm snapshot"

RDEPEND=">=dev-libs/openssl-1.0.1j[-bindist]
	icu? ( dev-libs/icu )
	>=net-libs/http-parser-2.3
	>=dev-libs/libuv-1.4.2"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	!!net-libs/nodejs"
S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if ! test-flag-CXX -std=c++11 ; then
		die "Your compiler doesn't support C++11. Use GCC 4.8, Clang 3.3 or newer."
	fi
}

src_prepare() {
	# fix compilation on Darwin
	# http://code.google.com/p/gyp/issues/detail?id=260
	sed -i -e "/append('-arch/d" tools/gyp/pylib/gyp/xcode_emulation.py || die

	# make sure we use python2.* while using gyp
	sed -i -e "s/python/python2/" deps/npm/node_modules/node-gyp/gyp/gyp || die
	sed -i -e "s/|| 'python'/|| 'python2'/" deps/npm/node_modules/node-gyp/lib/configure.js || die

	# less verbose install output (stating the same as portage, basically)
	sed -i -e "/print/d" tools/install.py || die

	# proper libdir, hat tip @ryanpcmcquen https://github.com/iojs/io.js/issues/504
	local LIBDIR=$(get_libdir)
	sed -i -e "s|lib/|${LIBDIR}/|g" tools/install.py || die
	sed -i -e "s/'lib'/'${LIBDIR}'/" lib/module.js || die
	sed -i -e "s|\"lib\"|\"${LIBDIR}\"|" deps/npm/lib/npm.js || die

	epatch "${FILESDIR}"/${PN}-1.2.0-pkgconfig.patch

	# Avoid a test that I've only been able to reproduce from emerge. It doesnt
	# seem sandbox related either (invoking it from a sandbox works fine).
	# The issue is that no stdin handle is openened when asked for one.
	# It doesn't really belong upstream , so it'll just be removed until someone
	# with more gentoo-knowledge than me (jbergstroem) figures it out.
	rm test/parallel/test-stdout-close-unref.js
}

src_configure() {
	tc-export CC CXX PKG_CONFIG
	export V=1

	local myconf=()
	local myarch=""
	! use npm && myconf+=( --without-npm )
	use icu && myconf+=( --with-intl=system-icu )
	use snapshot && myconf+=( --with-snapshot )

	case ${ARCH} in
	x86) myarch="ia32";;
	amd64)
		case ${ABI} in
		x86) myarch="ia32";;
		x32) myarch="x32";;
		*) myarch="x64";;
		esac
		;;
	arm) myarch="arm";;
	*) die "Unrecognized ARCH ${ARCH}";;
	esac

	"${PYTHON}" configure \
		--prefix="${EPREFIX}"/usr \
		--shared-openssl \
		--shared-libuv \
		--shared-http-parser \
		--shared-zlib \
		--dest-cpu=${myarch} \
		--without-dtrace \
		"${myconf[@]}" || die
}

src_install() {
	local LIBDIR="${ED}/usr/$(get_libdir)"
	emake install DESTDIR="${ED}"

	use npm && dohtml -r "${LIBDIR}"/node_modules/npm/html/*
	rm -rf "${LIBDIR}"/node_modules/npm/{doc,html}
	rm -rf "${LIBDIR}"/dtrace
	find "${LIBDIR}"/node_modules -type f -name "LICENSE" -delete

	pax-mark -m "${ED}"/usr/bin/iojs
}
