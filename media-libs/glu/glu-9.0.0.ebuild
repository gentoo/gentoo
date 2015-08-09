# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/glu"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
fi

inherit autotools-utils multilib ${GIT_ECLASS}

DESCRIPTION="The OpenGL Utility Library"
HOMEPAGE="http://cgit.freedesktop.org/mesa/glu/"

if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="ftp://ftp.freedesktop.org/pub/mesa/${PN}/${P}.tar.bz2"
fi

LICENSE="SGI-B-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="multilib static-libs"

DEPEND="virtual/opengl"
RDEPEND="${DEPEND}
	!<media-libs/mesa-9
	multilib? ( !app-emulation/emul-linux-x86-opengl )"

foreachabi() {
	if use multilib; then
		local ABI
		for ABI in $(get_all_abis); do
			multilib_toolchain_setup ${ABI}
			AUTOTOOLS_BUILD_DIR=${WORKDIR}/${ABI} "${@}"
		done
	else
		"${@}"
	fi
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]] && has collision-protect ${FEATURES}; then
		if [[ $(readlink "${EPREFIX}"/usr/$(get_libdir)/libGLU$(get_libname)) == *opengl* ]]; then
			eerror "FEATURES=\"collision-protect\" is enabled, which will prevent overwriting"
			eerror "symlinks that were formerly managed by eselect opengl. You must disable"
			eerror "collision-protect or remove ${EPREFIX}/usr/$(get_libdir)/libGLU$(get_libname)*"
			eerror "manually. For details see bug #435682."
			die "collision-protect cannot overwrite libGLU$(get_libname)*"
		fi
	fi
}

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-2_src_unpack
}

src_prepare() {
	AUTOTOOLS_AUTORECONF=1 autotools-utils_src_prepare
}

src_configure() {
	foreachabi autotools-utils_src_configure
}

src_compile() {
	foreachabi autotools-utils_src_compile
}

src_install() {
	foreachabi autotools-utils_src_install
}

src_test() {
	:;
}
