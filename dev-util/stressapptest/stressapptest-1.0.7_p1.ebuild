# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/stressapptest/stressapptest-1.0.7_p1.ebuild,v 1.1 2014/08/05 02:23:08 vapier Exp $

# This is the 1.0.7 release:
#  https://code.google.com/p/stressapptest/source/detail?r=44
# With the one follow up fix applied (hence the p1).

EAPI="4"

inherit flag-o-matic

DESCRIPTION="Stressful Application Test"
HOMEPAGE="http://code.google.com/p/stressapptest/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE="debug"

RDEPEND="dev-libs/libaio"
DEPEND="${RDEPEND}"

src_configure() {
	# Matches the configure & sat.cc logic
	use debug || append-cppflags -DNDEBUG -DCHECKOPTS
	econf --disable-default-optimizations
}
