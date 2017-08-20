# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils

COMMIT=7d3a76510d38ad650854382d2dcc502beb91642a

DESCRIPTION="Elementary icons forked from upstream, extended and maintained for Xfce"
HOMEPAGE="https://github.com/shimmerproject/elementary-xfce"
SRC_URI="${HOMEPAGE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="public-domain GPL-1 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}/elementary-xfce-${COMMIT}

src_install() {
	insinto /usr/share/icons/
	dodoc README
	for shade in elementary-xfce*; do
		for doc in {AUTHORS,CONTRIBUTORS,LICENSE}; do
			if [[ -f ${shade}/${doc} ]]; then
				newdoc ${shade}/${doc} ${shade}-${doc}
				rm -f ${shade}/${doc} || die
			elif [[ -L ${shade}/${doc} ]]; then
				unlink ${shade}/${doc} || die
			fi
		done
		doins -r ${shade}
	done
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
