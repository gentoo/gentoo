# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit perl-module

DESCRIPTION="A text-mode MySQL and InnoDB monitor like mytop, but with many more features"
HOMEPAGE="https://github.com/innotop/innotop"
SRC_URI="https://github.com/innotop/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
SLOT="0"
IUSE=""

DEPEND="dev-perl/DBI
	dev-perl/DBD-mysql
	dev-perl/TermReadKey
	virtual/perl-Term-ANSIColor
	virtual/perl-Time-HiRes"

DIST_TEST="do parallel"

src_install() {
	perl-module_src_install
}
