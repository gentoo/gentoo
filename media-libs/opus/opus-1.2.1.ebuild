# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.xiph.org/opus.git"
else
	SRC_URI="https://archive.mozilla.org/pub/opus/${P}.tar.gz"
	if [[ "${PV}" != *_alpha* ]] &&  [[ "${PV}" != *_beta* ]] ; then
		KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~ppc ~ppc64 sparc ~x86 ~amd64-fbsd"
	fi
fi

DESCRIPTION="Open codec designed for internet transmission of interactive speech and audio"
HOMEPAGE="https://opus-codec.org/"

LICENSE="BSD-2"
SLOT="0"
INTRINSIC_FLAGS="cpu_flags_x86_sse cpu_flags_arm_neon"
IUSE="ambisonics custom-modes doc static-libs ${INTRINSIC_FLAGS}"

DEPEND="doc? ( app-doc/doxygen media-gfx/graphviz )"

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable ambisonics)
		$(use_enable custom-modes)
		$(use_enable doc)
		$(use_enable static-libs static)
	)
	for i in ${INTRINSIC_FLAGS} ; do
		use ${i} && myeconfargs+=( --enable-intrinsics )
	done
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}
