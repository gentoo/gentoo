# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2-utils

COMMIT="e55d4a0c9d05d3303f6c981dc519527fedd9ea29"

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
				rm -f ${shade}/${doc}
			fi
		done
		doins -r ${shade}
	done
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
