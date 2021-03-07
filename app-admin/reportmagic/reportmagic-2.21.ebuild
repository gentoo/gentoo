# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Makes usable statistics from your web site log file analysis"
HOMEPAGE="http://www.reportmagic.org/"
SRC_URI="http://www.reportmagic.org/rmagic-${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="truetype"

DEPEND="sys-libs/zlib
	media-libs/libpng
	media-libs/gd
	truetype? ( media-libs/freetype )
	virtual/jpeg
	dev-perl/GD
	dev-perl/Config-IniFiles
	virtual/perl-File-Spec
	dev-perl/HTML-Tagset
	dev-perl/HTML-Parser
	dev-perl/GDGraph
	virtual/perl-File-Temp
	dev-perl/GD-Graph3d"

S="${WORKDIR}/rmagic-${PV}"

src_unpack() {
	unpack ${A} ; cd "${S}"

	sed -i \
		-e "s:^\$DEST.*:\$DEST='${D}/usr/share/reportmagic';:g" \
		-e "s:^\$DOC.*:\$DOC='${D}/usr/share/doc/${PF}';:g" \
		Install.PL \
		|| die "sed failed"
}

src_install() {
	perl Install.PL -no_modules
}
