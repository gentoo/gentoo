# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/nodejs/nodejs-0.8.28.ebuild,v 1.1 2014/08/01 06:02:08 patrick Exp $

EAPI=5

PYTHON_DEPEND="2"

inherit python eutils multilib pax-utils

# omgwtf
RESTRICT="test"

DESCRIPTION="Evented IO for V8 Javascript"
HOMEPAGE="http://nodejs.org/"
SRC_URI="http://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${PYTHON_DEPS}
	${DEPEND}"

S=${WORKDIR}/node-v${PV}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# fix compilation on Darwin
	# http://code.google.com/p/gyp/issues/detail?id=260
	sed -i -e "/append('-arch/d" tools/gyp/pylib/gyp/xcode_emulation.py || die
	python_convert_shebangs 2 tools/node-waf || die
}

src_configure() {
	# this is an autotools lookalike confuserator
	./configure --prefix="${EPREFIX}"/usr --openssl-use-sys --shared-zlib || die
}

src_compile() {
	emake || die
}

src_install() {
	local MYLIB=$(get_libdir)
	mkdir -p "${ED}"/usr/include/node
	mkdir -p "${ED}"/usr/bin
	mkdir -p "${ED}"/usr/"${MYLIB}"/node_modules/npm
	mkdir -p "${ED}"/usr/"${MYLIB}"/node
	cp 'src/eio-emul.h' 'src/ev-emul.h' 'src/node.h' 'src/node_buffer.h' 'src/node_object_wrap.h' 'src/node_version.h' "${ED}"/usr/include/node || die "Failed to copy stuff"
	cp -R deps/uv/include/* "${ED}"/usr/include/node || die "Failed to copy stuff"
	cp -R deps/v8/include/* "${ED}"/usr/include/node || die "Failed to copy stuff"
	cp 'out/Release/node' "${ED}"/usr/bin/node || die "Failed to copy stuff"
	cp -R deps/npm/* "${ED}"/usr/"${MYLIB}"/node_modules/npm || die "Failed to copy stuff"
	cp -R tools/wafadmin "${ED}"/usr/"${MYLIB}"/node/ || die "Failed to copy stuff"
	cp 'tools/node-waf' "${ED}"/usr/bin/ || die "Failed to copy stuff"

	# now add some extra stupid just because we can
	# needs to be a symlink because of hardcoded paths ... no es bueno!
	dosym /usr/"${MYLIB}"/node_modules/npm/bin/npm-cli.js /usr/bin/npm
	pax-mark -m "${ED}"/usr/bin/node
}

src_test() {
	emake test || die
}
