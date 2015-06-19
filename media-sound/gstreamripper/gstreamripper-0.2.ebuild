# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gstreamripper/gstreamripper-0.2.ebuild,v 1.15 2012/05/05 08:27:39 mgorny Exp $

EAPI=4
inherit eutils

MY_P=GStreamripperX-${PV}

DESCRIPTION="A GTK+ toolkit based frontend for streamripper"
HOMEPAGE="http://sourceforge.net/projects/gstreamripper/"
SRC_URI="mirror://sourceforge/gstreamripper/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

COMMON_DEPEND="x11-libs/gtk+:2"
RDEPEND="${COMMON_DEPEND}
	media-sound/streamripper"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_install() {
	local docdir=/usr/share/doc/${PF}

	emake \
		DESTDIR="${D}" \
		gstreamripperxdocdir=${docdir} \
		install || die

	rm -f "${D}"/${docdir}/{COPYING,NEWS,TODO}

	make_desktop_entry gstreamripperx GStreamripperX
}
