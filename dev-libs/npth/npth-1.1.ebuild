# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/npth/npth-1.1.ebuild,v 1.5 2015/05/21 04:27:43 mattst88 Exp $

EAPI=5
inherit autotools-utils

DESCRIPTION="New GNU Portable Threads Library"
HOMEPAGE="http://thread.gmane.org/gmane.comp.encryption.gpg.announce/179"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="static-libs"
