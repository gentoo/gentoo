# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

MY_P=GStreamripperX-${PV}

DESCRIPTION="A GTK+ toolkit based frontend for streamripper"
HOMEPAGE="https://sourceforge.net/projects/gstreamripper/"
SRC_URI="mirror://sourceforge/gstreamripper/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	x11-libs/gtk+:2
	media-sound/streamripper"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2-clang16-int-conversion.patch
)

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
