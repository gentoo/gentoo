# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	inherit git-2
	EGIT_REPO_URI="git://git.opus-codec.org/opus.git"
else
	SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
fi

DESCRIPTION="Open versatile codec designed for interactive speech and audio transmission over the internet"
HOMEPAGE="http://opus-codec.org/"
SRC_URI="http://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
INTRINSIC_FLAGS="cpu_flags_x86_sse neon"
IUSE="ambisonics custom-modes doc static-libs ${INTRINSIC_FLAGS}"

DEPEND="doc? ( app-doc/doxygen )"

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable custom-modes)
		$(use_enable ambisonics)
		$(use_enable doc)
	)
	for i in ${INTRINSIC_FLAGS} ; do
		use ${i} && myeconfargs+=( --enable-intrinsics )
	done
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}
