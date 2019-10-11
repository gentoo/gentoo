# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_/-}"
inherit multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.xiph.org/opus.git"
else
	SRC_URI="https://archive.mozilla.org/pub/opus/${MY_P}.tar.gz"
	if [[ "${PV}" != *_alpha* ]] && [[ "${PV}" != *_beta* ]] ; then
		KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86"
	fi
fi

DESCRIPTION="Open codec designed for internet transmission of interactive speech and audio"
HOMEPAGE="https://opus-codec.org/"

LICENSE="BSD"
SLOT="0"
INTRINSIC_FLAGS="cpu_flags_x86_sse cpu_flags_arm_neon"
IUSE="custom-modes doc static-libs ${INTRINSIC_FLAGS}"

DEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable custom-modes)
		$(use_enable doc)
		$(use_enable static-libs static)
	)
	for i in ${INTRINSIC_FLAGS} ; do
		use ${i} && myeconfargs+=( --enable-intrinsics )
	done
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -name "*.la" -delete || die
}
