# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/tdb/tdb-1.3.7.ebuild,v 1.2 2015/08/08 09:18:14 polynomial-c Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit waf-utils multilib-minimal python-single-r1 eutils

DESCRIPTION="A simple database API"
HOMEPAGE="http://tdb.samba.org/"
SRC_URI="http://samba.org/ftp/tdb/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="python"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.2"

WAF_BINARY="${S}/buildtools/bin/waf"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3.7-fix.patch
	python_fix_shebang .
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

multilib_src_compile() {
	# need to avoid parallel building, this looks like the sanest way with waf-utils/multiprocessing eclasses
	unset MAKEOPTS
	waf-utils_src_compile
}

multilib_src_test() {
	# the default src_test runs 'make test' and 'make check', letting
	# the tests fail occasionally (reason: unknown)
	emake check
}

multilib_src_install() {
	waf-utils_src_install
}
