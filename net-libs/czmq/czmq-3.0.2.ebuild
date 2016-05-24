# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="High-level C Binding for ZeroMQ"
HOMEPAGE="http://czmq.zeromq.org"
SRC_URI="http://download.zeromq.org/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 arm ~hppa ~x86"
IUSE="doc static-libs test"

RDEPEND="
	sys-apps/util-linux
	net-libs/zeromq
"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
"

DOCS=( NEWS AUTHORS )

# Network access
RESTRICT=test

src_prepare() {
	use test && AUTOTOOLS_IN_SOURCE_BUILD=1
	sed -i -e 's|-Werror||g' configure.ac || die

	cat >> src/Makemodule-local.am <<-EOF
	src_libczmq_la_LDFLAGS += -pthread
	EOF

	autotools-utils_src_prepare
}

src_test() {
	autotools-utils_src_test check-verbose VERBOSE=1
}

src_install() {
	autotools-utils_src_install
	mv "${ED}"/usr/bin/makecert{,-czmq} || die
	mv "${ED}"/usr/share/man/man1/makecert{,-cmzq}.1 || die
}

pkg_postinst() {
	elog "Due to file collisions we moved the makecert tool to makecert-${PN}."
}
