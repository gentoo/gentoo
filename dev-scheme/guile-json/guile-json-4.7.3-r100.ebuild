# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit guile

DESCRIPTION="JSON module for Guile"
HOMEPAGE="https://savannah.nongnu.org/projects/guile-json/"
SRC_URI="http://download.savannah.nongnu.org/releases/guile-json/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"
