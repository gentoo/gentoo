# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="threads(+)"

inherit waf-utils multilib-minimal python-single-r1

DESCRIPTION="Samba tevent library"
HOMEPAGE="https://tevent.samba.org/"
SRC_URI="https://www.samba.org/ftp/tevent/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~x86-linux"
IUSE="elibc_glibc python"

RDEPEND="!elibc_FreeBSD? ( dev-libs/libbsd[${MULTILIB_USEDEP}] )
	>=sys-libs/talloc-2.1.16[${MULTILIB_USEDEP}]
	python? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	elibc_glibc? (
		net-libs/libtirpc[${MULTILIB_USEDEP}]
		|| (
			net-libs/rpcsvc-proto
			<sys-libs/glibc-2.26[rpc(+)]
		)
	)
	${PYTHON_DEPS}
"
# build system does not work with python3
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

WAF_BINARY="${S}/buildtools/bin/waf"

RESTRICT="test"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	waf-utils_src_configure \
		--bundled-libraries=NONE \
		--builtin-libraries=NONE \
		$(multilib_native_usex python '' '--disable-python')
}

multilib_src_compile() {
	# need to avoid parallel building, this looks like the sanest way with waf-utils/multiprocessing eclasses
	unset MAKEOPTS
	waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install

	multilib_is_native_abi && use python && python_domodule tevent.py
}

multilib_src_install_all() {
	insinto /usr/include
	doins tevent_internal.h
}
