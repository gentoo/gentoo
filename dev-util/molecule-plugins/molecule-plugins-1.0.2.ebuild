# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_DEPEND="*"

inherit python

DESCRIPTION="A set fo base plugins for Molecule"
HOMEPAGE="http://www.sabayon.org"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-util/molecule-core-1.0.1 !<dev-util/molecule-1"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	net-misc/rsync
	sys-fs/squashfs-tools
	sys-process/lsof
	virtual/cdrtools"

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/lib" \
		PREFIX="/usr" SYSCONFDIR="/etc" install \
		|| die "emake install failed"
}

pkg_postinst() {
	python_mod_optimize "/usr/lib/molecule"
}

pkg_postrm() {
	python_mod_cleanup "/usr/lib/molecule"
}
