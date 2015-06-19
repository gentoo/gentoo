# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/tivodecode/tivodecode-0.2_pre4.ebuild,v 1.2 2009/01/31 00:41:11 gengor Exp $

inherit eutils versionator

MY_PV="$(delete_version_separator '_')"

DESCRIPTION="TiVo File Decoder"
HOMEPAGE="http://tivodecode.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog
}
