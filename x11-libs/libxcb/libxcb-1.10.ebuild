# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE=xml

XORG_DOC=doc
XORG_MULTILIB=yes
inherit python-any-r1 xorg-2

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="https://xcb.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/xcb/libxcb"
[[ ${PV} != 9999* ]] && \
	SRC_URI="https://xcb.freedesktop.org/dist/${P}.tar.bz2"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="selinux xkb"

RDEPEND=">=dev-libs/libpthread-stubs-0.3-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXau-1.0.7-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXdmcp-1.1.1-r1[${MULTILIB_USEDEP}]"
# Note: ${PYTHON_USEDEP} needs to go verbatim
DEPEND="${RDEPEND}
	dev-libs/libxslt
	${PYTHON_DEPS}
	$(python_gen_any_dep \
		">=x11-proto/xcb-proto-1.10[${MULTILIB_USEDEP},\${PYTHON_USEDEP}]")"

python_check_deps() {
	has_version --host-root ">=x11-proto/xcb-proto-1.10[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc build-docs)
		$(use_enable selinux)
		$(use_enable xkb)
		--enable-xinput
	)
	xorg-2_src_configure
}
