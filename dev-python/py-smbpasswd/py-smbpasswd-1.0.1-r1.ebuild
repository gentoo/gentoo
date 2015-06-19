# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/py-smbpasswd/py-smbpasswd-1.0.1-r1.ebuild,v 1.1 2014/12/31 10:11:53 idella4 Exp $
EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils

DESCRIPTION="This module can generate both LANMAN and NT password hashes, suitable for use with Samba"
HOMEPAGE="http://barryp.org/software/py-smbpasswd/"
SRC_URI="http://barryp.org/software/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
