# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils pam

DESCRIPTION="Allows you to require a special group or user to access a service"
HOMEPAGE="http://www.splitbrain.org/projects/pam_require"
SRC_URI="http://www.splitbrain.org/_media/projects/pamrequire/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/pam"

S=${WORKDIR}/${P/_/-}

src_compile() {
	./configure --prefix=/ || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dopammod "${S}/pam_require.so"

	dodoc AUTHORS ChangeLog NEWS README
}
