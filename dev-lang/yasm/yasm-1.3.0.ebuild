# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/yasm/yasm-1.3.0.ebuild,v 1.1 2015/04/03 23:13:35 vapier Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-r1

DESCRIPTION="An assembler for x86 and x86_64 instruction sets"
HOMEPAGE="http://yasm.tortall.net/"
SRC_URI="http://www.tortall.net/projects/yasm/releases/${P}.tar.gz"

LICENSE="BSD-2 BSD || ( Artistic GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64 ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE="nls python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )
	python? (
		${PYTHON_DEPS}
		>=dev-python/cython-0.14[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS )

src_configure() {
	use python && python_export_best

	XMLTO=: \
	econf \
		$(use_enable python) \
		$(use_enable python python-bindings) \
		$(use_enable nls)
}

src_test() {
	emake check
}
