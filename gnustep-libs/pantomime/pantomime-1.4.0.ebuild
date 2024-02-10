# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

MY_P=${P/p/P}

DESCRIPTION="Set of Objective-C classes that model a mail system"
HOMEPAGE="https://www.nongnu.org/gnustep-nonfsf/gnumail/"
SRC_URI="mirror://nongnu/gnustep-nonfsf/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+ Elm"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"

DEPEND="dev-libs/openssl:0=
	>=gnustep-base/gnustep-base-1.29.0:="
RDEPEND="${DEPEND}"

DOCS=( "${S}"/Documentation/AUTHORS
	"${S}"/Documentation/README
	"${S}"/Documentation/TODO
	"${S}"/Documentation/RFC
	)

src_install() {
	gnustep-base_src_install
	einstalldocs
}
