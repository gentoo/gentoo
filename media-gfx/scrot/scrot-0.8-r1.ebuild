# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/scrot/scrot-0.8-r1.ebuild,v 1.1 2014/08/27 13:50:44 mgorny Exp $

EAPI=5

inherit bash-completion-r1

DESCRIPTION="Screen capture utility using imlib2 library"
HOMEPAGE="http://www.linuxbrit.co.uk/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="feh LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/imlib2-1.0.3
	>=media-libs/giblib-1.2.3"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	rm -r "${D}"/usr/doc
	dodoc AUTHORS ChangeLog

	newbashcomp "${FILESDIR}/${PN}.bash-completion" ${PN}
}
