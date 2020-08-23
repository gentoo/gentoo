# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Synchronizes mail messages and notmuch tags across machines"
HOMEPAGE="http://www.muchsync.org/"
SRC_URI="http://www.muchsync.org/src/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-db/sqlite:3
	dev-libs/openssl:0=
	dev-libs/xapian:=
	net-mail/notmuch:=
	"
RDEPEND="${DEPEND}
	net-misc/openssh
	"
