# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-seekthru/lc-seekthru-9999.ebuild,v 1.1 2013/03/08 22:06:18 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="OpenSearch support for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
		virtual/leechcraft-search-show
		virtual/leechcraft-downloader-http"
