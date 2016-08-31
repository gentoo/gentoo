# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

# Duali uses "anydbm" which should even support a slow fallback;
# however, due to implementation details it fails when the databases
# aren't gdbm.
PYTHON_REQ_USE="gdbm"

inherit python-single-r1

DESCRIPTION="Arabic dictionary based on the DICT protocol"
HOMEPAGE="http://www.arabeyes.org/project.php?proj=Duali"
SRC_URI="mirror://sourceforge/arabeyes/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
PDEPEND=">=app-dicts/duali-data-0.1b-r1"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	python_fix_shebang duali dict2db trans2arabic arabic2trans
	python_doexe duali dict2db trans2arabic arabic2trans

	insinto /etc
	doins duali.conf

	doman doc/man/*.1
	dodoc README ChangeLog

	python_domodule pyduali
}
