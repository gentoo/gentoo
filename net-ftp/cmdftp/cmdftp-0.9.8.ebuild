# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/cmdftp/cmdftp-0.9.8.ebuild,v 1.3 2015/01/26 10:40:38 ago Exp $

EAPI=5

DESCRIPTION="Light weight, yet robust command line FTP client with shell-like
functions."
HOMEPAGE="http://savannah.nongnu.org/projects/cmdftp/"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS=( NEWS README AUTHORS )

src_configure() {
	econf --enable-largefile
}
