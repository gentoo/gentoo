# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xmodmap/xmodmap-1.0.9.ebuild,v 1.1 2015/07/07 17:57:33 mrueg Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="utility for modifying keymaps and pointer button mappings in X"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
