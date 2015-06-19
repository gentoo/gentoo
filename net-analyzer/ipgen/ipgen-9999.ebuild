# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ipgen/ipgen-9999.ebuild,v 1.1 2014/06/07 12:22:24 jer Exp $

EAPI=5
inherit autotools git-r3

DESCRIPTION="Generate list of IP addresses from a network specification"
HOMEPAGE="http://www.nta-monitor.com/tools-resources/security-tools/ipgen https://github.com/royhills/ipgen"
EGIT_REPO_URI="https://github.com/royhills/ipgen"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

src_prepare() {
	eautoreconf
}
