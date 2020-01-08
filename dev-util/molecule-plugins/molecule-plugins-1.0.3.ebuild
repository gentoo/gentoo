# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_6} )

inherit python-r1

DESCRIPTION="A set of base plugins for Molecule"
HOMEPAGE="http://www.sabayon.org"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	>=dev-util/molecule-core-1.0.1
	!<dev-util/molecule-1"
RDEPEND="${DEPEND}
	net-misc/rsync
	sys-fs/squashfs-tools
	sys-process/lsof
	virtual/cdrtools
	${PYTHON_DEPS}"

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/lib" \
		PREFIX="/usr" SYSCONFDIR="/etc" install
}
