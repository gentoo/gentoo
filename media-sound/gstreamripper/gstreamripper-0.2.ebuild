# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

MY_P=GStreamripperX-${PV}

DESCRIPTION="A GTK+ toolkit based frontend for streamripper"
HOMEPAGE="https://sourceforge.net/projects/gstreamripper/"
SRC_URI="mirror://sourceforge/gstreamripper/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	media-sound/streamripper"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	local docdir="${EPREFIX}/usr/share/doc/${PF}"
	emake \
		DESTDIR="${D}" \
		gstreamripperxdocdir="${docdir}" \
		install
	einstalldocs

	rm "${ED}"/${docdir}/COPYING || die

	make_desktop_entry gstreamripperx GStreamripperX
}
