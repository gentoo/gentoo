# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
PYTHON_REQ_USE="xml(+)"

XORG_MULTILIB=yes
XORG_DOC=doc

inherit python-any-r1 xorg-3

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb"

SLOT="0/1.12"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="doc selinux test +xkb"
RESTRICT="!test? ( test )"

XCB_PROTO_DEP=">=x11-base/xcb-proto-${PV}"
RDEPEND="
	>=x11-libs/libXau-1.0.7-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXdmcp-1.1.1-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	${XCB_PROTO_DEP}
	elibc_Darwin? ( dev-libs/libpthread-stubs )
	test? ( dev-libs/check[${MULTILIB_USEDEP}] )
"
# Note: ${PYTHON_USEDEP} needs to go verbatim
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep "${XCB_PROTO_DEP}"'[${PYTHON_USEDEP}]')
	doc? ( app-text/doxygen[dot] )
	test? ( dev-libs/libxslt )
"

python_check_deps() {
	python_has_version "${XCB_PROTO_DEP}[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	xorg-3_pkg_setup
}

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc devel-docs)
		$(use_enable selinux)
	)
	xorg-3_src_configure
}
