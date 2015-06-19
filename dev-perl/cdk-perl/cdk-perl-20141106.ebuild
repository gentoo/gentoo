# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/cdk-perl/cdk-perl-20141106.ebuild,v 1.1 2014/12/13 23:09:46 dilfridge Exp $

EAPI=5

inherit perl-module

DESCRIPTION="Perl extension for Cdk"
HOMEPAGE="http://invisible-island.net/cdk/cdk-perl.html"
SRC_URI="http://invisible-island.net/datafiles/release/cdk-perl.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/cdk-5.0.20090215"
DEPEND="${RDEPEND}"

src_configure() {
	default
	perl-module_src_configure
}
