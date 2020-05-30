# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
PYTHON_REQ_USE=xml

XORG_TARBALL_SUFFIX="xz"
XORG_MULTILIB=yes
XORG_DOC=doc

inherit python-any-r1 xorg-3

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc selinux test +xkb"
RESTRICT="!test? ( test )"
SLOT="0/1.12"

RDEPEND="
	>=x11-libs/libXau-1.0.7-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXdmcp-1.1.1-r1[${MULTILIB_USEDEP}]"
# Note: ${PYTHON_USEDEP} needs to go verbatim
DEPEND="${RDEPEND}
	>=x11-base/xcb-proto-1.14[${MULTILIB_USEDEP}]
	test? ( dev-libs/check[${MULTILIB_USEDEP}] )
	doc? ( app-doc/doxygen[dot] )
	dev-libs/libxslt
"
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep '>=x11-base/xcb-proto-1.14[${PYTHON_USEDEP}]')
"

python_check_deps() {
	has_version -b ">=x11-base/xcb-proto-1.14[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup

	XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc devel-docs)
		$(use_enable selinux)
	)
}
