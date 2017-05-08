# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
KDE_LINGUAS="cs de es fr it pl pt_BR ru uk"
KDE_HANDBOOK="optional"
MY_P="knc${PV//./}"

inherit kde4-base

DESCRIPTION="Visual client for UPS systems based on kdelibs-4"
HOMEPAGE="https://sites.google.com/a/prynych.cz/knutclient/"
SRC_URI="ftp://ftp.buzuluk.cz/pub/alo/knutclient/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

PATCHES=(
	"${FILESDIR}/${P}-desktop.patch"
	"${FILESDIR}/${P}-gcc6.patch"
)

DOCS=( ChangeLog )

S="${WORKDIR}/${MY_P}"
