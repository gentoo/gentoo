# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit gnustep-2

MY_P=SystemPreferences-${PV}
DESCRIPTION="System Preferences is a clone of Apple OS X' System Preferences"
HOMEPAGE="http://www.gnustep.it/enrico/system-preferences/"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/usr-apps/${MY_P}.tar.gz"

KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

S=${WORKDIR}/${MY_P}
