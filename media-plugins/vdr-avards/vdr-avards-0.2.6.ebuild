# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin:  Automatic Video Aspect Ratio Detection and Signaling"
HOMEPAGE="http://firefly.vdr-developer.org/avards/"
SRC_URI="http://firefly.vdr-developer.org/avards/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"

src_prepare() {
	vdr-plugin-2_src_prepare

	# revert wrong implementation of vdr-2.4. feature
	sed -i Makefile \
		-e "s:\$(INCLUDES) -o \$@ \$<:\$(INCLUDES) -o \$<:"
}
