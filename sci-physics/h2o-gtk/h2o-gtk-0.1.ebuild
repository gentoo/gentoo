# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/h2o-gtk/h2o-gtk-0.1.ebuild,v 1.2 2014/07/06 13:21:45 mgorny Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="GTK+ UI for libh2o -- water & steam properties"
HOMEPAGE="https://bitbucket.org/mgorny/h2o-gtk/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm
	>=sci-libs/libh2oxx-0.2
	sci-libs/plotmm"
DEPEND="${RDEPEND}"
