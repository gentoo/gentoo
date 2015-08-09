# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# has known failures. sigh.
RESTRICT="test"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit pax-utils python-single-r1 toolchain-funcs

DESCRIPTION="Evented IO for V8 Javascript"
HOMEPAGE="http://nodejs.org/"
SRC_URI="http://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz"

LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="debug icu +npm +snapshot +ssl"

RDEPEND="icu? ( dev-libs/icu )
	${PYTHON_DEPS}
	ssl? ( dev-libs/openssl:0=[-bindist] )
	>=net-libs/http-parser-2.3
	>=dev-libs/libuv-1.4.2"
DEPEND="${RDEPEND}
	!!net-libs/iojs"

S="${WORKDIR}/node-v${PV}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	tc-export CC CXX PKG_CONFIG
	export V=1 # Verbose build
	export BUILDTYPE=Release

	# fix compilation on Darwin
	# http://code.google.com/p/gyp/issues/detail?id=260
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

	# debug builds. change install path, remove optimisations and override buildtype
	if use debug; then
		sed -i -e "s|out/Release/|out/Debug/|g" tools/install.py || die
		BUILDTYPE=Debug
	fi
}

src_configure() {
	local myconf=()
	local myarch=""
	use debug && myconf+=( --debug )
	use icu && myconf+=( --with-intl=system-icu )
	use npm || myconf+=( --without-npm )
	use snapshot || myconf+=( --without-snapshot )
	use ssl || myconf+=( --without-ssl )

	case ${ABI} in
		x86) myarch="ia32";;
		amd64) myarch="x64";;
		arm) myarch="arm";;
		*) die "Unrecognized ARCH ${ARCH}";;
	esac

	"${PYTHON}" configure \
		--prefix="${EPREFIX}"/usr \
		--dest-cpu=${myarch} \
		--shared-openssl \
		--shared-libuv \
		--shared-http-parser \
		--shared-zlib \
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
	find "${LIBDIR}"/node_modules -type f -name "LICENSE*" -or -name "LICENCE*" -delete

	# set up a symlink structure that npm expects..
	dodir /usr/include/node/deps/{v8,uv}
	dosym . /usr/include/node/src
	for var in deps/{uv,v8}/include; do
		dosym ../.. /usr/include/node/${var}
	done

	pax-mark -m "${ED}"/usr/bin/node
}

src_test() {
	declare -xl TESTTYPE="${BUILDTYPE}"
	"${PYTHON}" tools/test.py --mode=${TESTTYPE} -J message simple || die
}

pkg_postinst() {
	einfo "When using node-gyp to install native modules, you can avoid"
	einfo "having to download the full tarball by doing the following:"
	einfo ""
	einfo "node-gyp --nodedir /usr/include/node <command>"
}
