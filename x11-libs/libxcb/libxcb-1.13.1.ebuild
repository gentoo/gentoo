# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )
PYTHON_REQ_USE=xml

XORG_DOC=doc
XORG_MULTILIB=yes
inherit python-any-r1 xorg-2

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="https://xcb.freedesktop.org/"
EGIT_REPO_URI="https://anongit.freedesktop.org/git/xcb/libxcb.git"
[[ ${PV} != 9999* ]] && \
	SRC_URI="https://xcb.freedesktop.org/dist/${P}.tar.bz2"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc selinux test xkb"
SLOT="0/1.12"

RDEPEND=">=dev-libs/libpthread-stubs-0.3-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXau-1.0.7-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXdmcp-1.1.1-r1[${MULTILIB_USEDEP}]"
# Note: ${PYTHON_USEDEP} needs to go verbatim
DEPEND="${RDEPEND}
	test? ( dev-libs/check[${MULTILIB_USEDEP}] )
	doc? ( app-doc/doxygen[dot] )
	dev-libs/libxslt
	${PYTHON_DEPS}
	$(python_gen_any_dep \
		">=x11-base/xcb-proto-1.13[${MULTILIB_USEDEP},\${PYTHON_USEDEP}]")"

python_check_deps() {
	has_version --host-root ">=x11-base/xcb-proto-1.13[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc devel-docs)
		$(use_enable selinux)
		$(use_enable xkb)
		--enable-xinput
	)
	xorg-2_src_configure
}
