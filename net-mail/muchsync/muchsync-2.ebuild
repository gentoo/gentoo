# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Synchronizes mail messages and notmuch tags across machines"
HOMEPAGE="http://www.muchsync.org/"
SRC_URI="http://www.muchsync.org/src/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-db/sqlite:3
	dev-libs/openssl:0=
	<dev-libs/xapian-1.3
	net-mail/notmuch:=
	"
RDEPEND="${DEPEND}
	net-misc/openssh
	"
