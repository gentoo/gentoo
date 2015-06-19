# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kdesu/kdesu-4.14.3.ebuild,v 1.1 2015/06/04 18:44:41 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kde-runtime"
inherit kde4-meta

# FIXME: Is default command ( su/sudo ) still configurable,
# if not, USE-flag ?
DESCRIPTION="KDE: gui for su(1)"
HOMEPAGE+=" http://techbase.kde.org/Projects/kdesu"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

src_configure() {
	# Upstream moved kdesu to libexec first, then decided to move it back
	# to /${PREFIX}/bin/ , so I'm doing that now already.
	sed -e '/kdesu_executable/s:LIBEXEC_INSTALL_DIR:BIN_INSTALL_DIR:' \
		-i "${S}"/kdesu/kdesu/CMakeLists.txt || \
		die "Moving kdesu from libexec to bin failed."

	kde4-meta_src_configure
}
