# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit waf-utils multilib-minimal python-single-r1

DESCRIPTION="Samba tevent library"
HOMEPAGE="https://tevent.samba.org/"
SRC_URI="https://samba.org/ftp/tevent/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x86-linux"
IUSE="python"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	>=sys-libs/talloc-2.3.4[${MULTILIB_USEDEP}]
	python? (
		${PYTHON_DEPS}
		sys-libs/talloc[python,${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	>=dev-util/cmocka-1.1.3
	elibc_glibc? (
		net-libs/libtirpc[${MULTILIB_USEDEP}]
		|| (
			net-libs/rpcsvc-proto
			<sys-libs/glibc-2.26[rpc(+)]
		)
	)
"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
"

WAF_BINARY="${S}/buildtools/bin/waf"

pkg_setup() {
	python-single-r1_pkg_setup
	export PYTHONHASHSEED=1
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
