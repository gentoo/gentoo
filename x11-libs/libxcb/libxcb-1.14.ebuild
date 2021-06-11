# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE=xml

XORG_TARBALL_SUFFIX="xz"
XORG_MULTILIB=yes
XORG_DOC=doc

inherit python-any-r1 xorg-3

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc selinux test +xkb"
RESTRICT="!test? ( test )"
SLOT="0/1.12"

RDEPEND="
	>=x11-libs/libXau-1.0.7-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXdmcp-1.1.1-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=x11-base/xcb-proto-1.14[${MULTILIB_USEDEP}]
	elibc_Darwin? ( dev-libs/libpthread-stubs )
	test? ( dev-libs/check[${MULTILIB_USEDEP}] )
"
# Note: ${PYTHON_USEDEP} needs to go verbatim
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep '>=x11-base/xcb-proto-1.14[${PYTHON_USEDEP}]')
	doc? ( app-doc/doxygen[dot] )
	test? ( dev-libs/libxslt )
"

PATCHES=(
	"${FILESDIR}"/${P}-tests-don-t-use-deprecated-fail_unless-check-API.patch
)

python_check_deps() {
	has_version -b ">=x11-base/xcb-proto-1.14[${PYTHON_USEDEP}]"
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
