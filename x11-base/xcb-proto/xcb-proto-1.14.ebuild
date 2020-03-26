# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
XORG_TARBALL_SUFFIX="xz"
XORG_MODULE=proto/
XORG_MULTILIB=yes
XORG_STATIC=no

inherit python-r1 xorg-3

DESCRIPTION="X C-language Bindings protocol headers"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/proto/xcbproto"
EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/proto/xcbproto.git"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="${PYTHON_DEPS}"
BDEPEND="dev-libs/libxml2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

multilib_src_compile() {
	default

	if multilib_is_native_abi; then
		python_foreach_impl emake -C xcbgen top_builddir="${BUILD_DIR}"
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		python_foreach_impl emake -C xcbgen top_builddir="${BUILD_DIR}"
		python_foreach_impl python_optimize
	fi
}
