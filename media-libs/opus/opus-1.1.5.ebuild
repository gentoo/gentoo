# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	inherit git-2
	EGIT_REPO_URI="git://git.opus-codec.org/opus.git"
else
	SRC_URI="https://archive.mozilla.org/pub/${PN}/${P}.tar.gz
		http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
fi

DESCRIPTION="Open codec designed for internet transmission of interactive speech and audio"
HOMEPAGE="http://opus-codec.org/"
SRC_URI="http://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"

# ABI -> intrinsics cpu flag (must have only one flag per abi)
INTRINSIC_ABI_MAP="x86:cpu_flags_x86_sse amd64:cpu_flags_x86_sse arm:neon arm64:neon"
IUSE="ambisonics custom-modes doc static-libs"
for i in ${INTRINSIC_ABI_MAP} ; do
	IUSE="${IUSE} ${i#*:}"
done

DEPEND="doc? ( app-doc/doxygen )"

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable custom-modes)
		$(use_enable ambisonics)
		$(use_enable doc)
	)
	for i in ${INTRINSIC_ABI_MAP} ; do
		local abi=${i%:*}
		local flag=${i#*:}
		if [ x"${ABI}" = x"${abi}" ] ; then
			use ${flag} || myeconfargs+=( --disable-intrinsics )
		fi
	done
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}
