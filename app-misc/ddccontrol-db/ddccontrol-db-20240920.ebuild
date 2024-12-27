# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="DDCControl monitor database"
HOMEPAGE="https://github.com/ddccontrol/ddccontrol-db"
SRC_URI="https://github.com/ddccontrol/ddccontrol-db/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

BDEPEND="
	dev-util/intltool
	dev-perl/XML-Parser
	nls? ( sys-devel/gettext )"

src_prepare() {
	touch db/options.xml.h ABOUT-NLS config.rpath || die
	eapply_user
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}
