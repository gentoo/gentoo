# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/innotop/innotop-1.9.0-r1.ebuild,v 1.1 2013/08/29 15:04:15 idella4 Exp $

EAPI=5

inherit perl-module

DESCRIPTION="innotop - A text-mode MySQL and InnoDB monitor like mytop, but with many more features"
HOMEPAGE="http://code.google.com/p/innotop/"
SRC_URI="http://innotop.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
SLOT="0"
IUSE=""

DEPEND="dev-perl/DBD-mysql
	dev-perl/TermReadKey
	virtual/perl-Term-ANSIColor
	virtual/perl-Time-HiRes"
SRC_TEST="do"

src_install() {
	perl-module_src_install
}
