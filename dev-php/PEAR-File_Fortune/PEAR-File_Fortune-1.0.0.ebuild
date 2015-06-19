# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-File_Fortune/PEAR-File_Fortune-1.0.0.ebuild,v 1.5 2015/04/14 17:53:35 grknight Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Interface for reading from and writing to fortune files"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.1.4:*"
RDEPEND="${DEPEND}"
