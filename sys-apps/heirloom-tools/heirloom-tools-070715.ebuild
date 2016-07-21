# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit flag-o-matic toolchain-funcs

# slightly broken
RESTRICT="test"

DESCRIPTION="Heirloom toolchest - original Unix tools"
HOMEPAGE="http://heirloom.sourceforge.net/tools.html"
SRC_URI="http://downloads.sourceforge.net/project/heirloom/heirloom/${PV}/heirloom-${PV}.tar.bz2"

LICENSE="CDDL GPL-2 LGPL-2.1 9base ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/ed
	sys-libs/zlib[static-libs]"
RDEPEND=""

S="${WORKDIR}/heirloom-${PV}"

src_compile() {
	append-cppflags -D_GNU_SOURCE
	emake -j1 ||die
}

src_install() {
	# we don't want to strip here, so use "true" as noop
	emake STRIP="true" ROOT="${D}" -j1 install || die
}

pkg_postinst() {
	elog "You may want to add /usr/5bin or /usr/ucb to \$PATH"
	elog "to enable using the apps of heirloom toolchest by default."
	elog "Man pages are installed in /usr/share/man/5man/"
	elog "You may need to set \$MANPATH to access them."
}
