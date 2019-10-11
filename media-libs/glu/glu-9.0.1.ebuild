# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/glu.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit autotools multilib-minimal ${GIT_ECLASS}

DESCRIPTION="The OpenGL Utility Library"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/glu"

if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="https://mesa.freedesktop.org/archive/glu/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="SGI-B-2.0"
SLOT="0"
IUSE="static-libs"

DEPEND=">=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}
	!<media-libs/mesa-9"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

src_test() {
	:;
}
