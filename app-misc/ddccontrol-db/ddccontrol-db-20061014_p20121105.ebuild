# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ddccontrol-db/ddccontrol-db-20061014_p20121105.ebuild,v 1.3 2014/03/12 05:04:12 phajdan.jr Exp $

EAPI=5

inherit autotools

DESCRIPTION="DDCControl monitor database"
HOMEPAGE="http://ddccontrol.sourceforge.net/"
COMMIT_ID="130da80af5cd5d2897ffeed63362262262c6944f"
SRC_URI="https://github.com/ddccontrol/ddccontrol-db/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

S=${WORKDIR}/${PN}-${COMMIT_ID}

RDEPEND="nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
		dev-util/intltool
		dev-perl/XML-Parser"

src_prepare(){
	touch db/options.xml.h ABOUT-NLS config.rpath || die
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
}
