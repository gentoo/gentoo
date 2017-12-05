# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.xiph.org/opus.git"
else
	SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd"
fi

DESCRIPTION="Open codec designed for internet transmission of interactive speech and audio"
HOMEPAGE="http://opus-codec.org/"
SRC_URI="http://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
INTRINSIC_FLAGS="cpu_flags_x86_sse neon"
IUSE="ambisonics custom-modes doc static-libs ${INTRINSIC_FLAGS}"

DEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.3-CVE-2017-0381.patch
)

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
