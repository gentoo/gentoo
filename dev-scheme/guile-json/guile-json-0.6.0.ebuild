# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="JSON module for Guile"
HOMEPAGE="http://savannah.nongnu.org/projects/guile-json/"
SRC_URI="http://download.savannah.gnu.org/releases/guile-json/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-scheme/guile"
DEPEND="${RDEPEND}"
