# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit waf-utils multilib-minimal python-single-r1

DESCRIPTION="A not-so trivial keyword/data database system"
HOMEPAGE="http://tdb.samba.org/"
SRC_URI="http://samba.org/ftp/tdb/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="!<net-fs/samba-4.1.7
	${RDEPEND}
	${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.2"

WAF_BINARY="${S}/buildtools/bin/waf"

src_prepare() {
	multilib_copy_sources
}

multilib_src_configure() {
	local extra_opts=()
	if ! multilib_is_native_abi || ! use python; then
		extra_opts+=( --disable-python )
	fi

	waf-utils_src_configure \
		"${extra_opts[@]}"
}

multilib_src_test() {
	# the default src_test runs 'make test' and 'make check', letting
	# the tests fail occasionally (reason: unknown)
	emake check
}

multilib_src_install() {
	waf-utils_src_install
}
