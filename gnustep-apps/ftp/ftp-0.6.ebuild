# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

MY_P="FTP-${PV}"

DESCRIPTION="FTP client for GNUstep"
HOMEPAGE="https://gap.nongnu.org/ftp/"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
