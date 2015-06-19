# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Services_TinyURL/PEAR-Services_TinyURL-0.1.2.ebuild,v 1.4 2014/08/10 20:55:18 slyfox Exp $

EAPI=4

inherit php-pear-r1

DESCRIPTION="An interface for creating TinyURLs with their API and looking up destinations of given TinyURLs"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/php[curl]"
