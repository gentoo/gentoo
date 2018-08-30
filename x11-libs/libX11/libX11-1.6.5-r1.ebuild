# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_DOC=doc
XORG_EAUTORECONF=yes
XORG_MULTILIB=yes
inherit xorg-2 toolchain-funcs

DESCRIPTION="X.Org X11 library"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="ipv6 test"

RDEPEND="x11-base/xorg-proto
	>=x11-libs/libxcb-1.11.1[${MULTILIB_USEDEP}]
	x11-libs/xtrans"
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
