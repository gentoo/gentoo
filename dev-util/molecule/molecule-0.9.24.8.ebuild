# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/molecule/molecule-0.9.24.8.ebuild,v 1.1 2013/02/12 11:19:00 lxnay Exp $

EAPI="3"
PYTHON_DEPEND="*"

inherit python

DESCRIPTION="Release metatool used for creating Sabayon (and Gentoo) releases"
HOMEPAGE="http://www.sabayon.org"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/intltool
	sys-devel/gettext"
RDEPEND="net-misc/rsync
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
