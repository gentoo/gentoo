# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/cvsspam/cvsspam-0.2.12.ebuild,v 1.3 2014/02/04 01:42:14 creffett Exp $

EAPI=5

inherit eutils

DESCRIPTION="Utility to send colored HTML CVS-mails"
HOMEPAGE="http://www.badgers-in-foil.co.uk/projects/cvsspam/"
SRC_URI="http://www.badgers-in-foil.co.uk/projects/cvsspam/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="subversion"

RDEPEND="dev-lang/ruby
	subversion? ( dev-vcs/subversion )
"

src_prepare() {
	use subversion && epatch "${FILESDIR}/${P}-svn.patch"
}

src_install() {
	dobin collect_diffs.rb
	dobin cvsspam.rb
	dobin record_lastdir.rb
	insinto /etc/cvsspam
	doins cvsspam.conf

	dohtml cvsspam-doc.html
	dodoc CREDITS TODO cvsspam-doc.pdf
}
