# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/npth/npth-1.0.ebuild,v 1.3 2015/04/26 12:49:51 blueness Exp $

EAPI=5
inherit autotools-utils

DESCRIPTION="New GNU Portable Threads Library"
HOMEPAGE="http://thread.gmane.org/gmane.comp.encryption.gpg.announce/179"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="static-libs"
