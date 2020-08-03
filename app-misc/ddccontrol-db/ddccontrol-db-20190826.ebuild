# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

DESCRIPTION="DDCControl monitor database"
HOMEPAGE="http://ddccontrol.sourceforge.net/"
#COMMIT_ID="..."
MY_PV=${COMMIT_ID:-${PV}}
SRC_URI="https://github.com/ddccontrol/ddccontrol-db/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

S=${WORKDIR}/${PN}-${MY_PV}

RDEPEND="nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
		dev-util/intltool
		dev-perl/XML-Parser"

src_prepare() {
	touch db/options.xml.h ABOUT-NLS config.rpath || die
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README.md
}
