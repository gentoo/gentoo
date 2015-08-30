# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator

DESCRIPTION="A library for the sidplay2 fork with resid-fp"
HOMEPAGE="http://sourceforge.net/projects/sidplay-residfp/"
SRC_URI="mirror://sourceforge/sidplay-residfp/${PN}/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="cpu_flags_x86_mmx static-libs"

DOCS=( AUTHORS NEWS README TODO )

src_prepare() {
	# fix automagic. warning: modifying .ac triggers maintainer mode.
	sed -i -e 's:doxygen:dIsAbLe&:' configure || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_mmx mmx)
}

src_install() {
	default
	prune_libtool_files
}
