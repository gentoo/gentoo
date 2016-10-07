# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_DOC=doc
# needs automake-1.14 without eautoreconf
XORG_EAUTORECONF=yes
XORG_MULTILIB=yes
inherit xorg-2 toolchain-funcs

DESCRIPTION="X.Org X11 library"

KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="ipv6 test"

RDEPEND=">=x11-libs/libxcb-1.11.1[${MULTILIB_USEDEP}]
	x11-libs/xtrans
	>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
	>=x11-proto/xf86bigfontproto-1.2.0-r1[${MULTILIB_USEDEP}]
	>=x11-proto/inputproto-2.3[${MULTILIB_USEDEP}]
	>=x11-proto/kbproto-1.0.6-r1[${MULTILIB_USEDEP}]
	>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.4-aix-pthread.patch
	"${FILESDIR}"/${PN}-1.1.5-winnt-private.patch
	"${FILESDIR}"/${PN}-1.1.5-solaris.patch
)

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_with doc xmlto)
		$(use_enable doc specs)
		$(use_enable ipv6)
		--without-fop
	)

	[[ ${CHOST} == *-interix* ]] && export ac_cv_func_poll=no
	xorg-2_src_configure
}

multilib_src_compile() {
	if tc-is-cross-compiler; then
		# Make sure the build-time tool "makekeys" uses build settings.
		tc-export_build_env BUILD_CC
		emake -C src/util \
			CC="${BUILD_CC}" \
			CFLAGS="${BUILD_CFLAGS}" \
			LDFLAGS="${BUILD_LDFLAGS}" \
			clean all
	fi

	default
}
