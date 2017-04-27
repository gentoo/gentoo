# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="osinfo database files"
HOMEPAGE="http://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.xz"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-apps/osinfo-db-tools
"
# we don't depend on intltool here, contrary to README, as the tarball already
# contains the processed results with translations in XML files

src_unpack() { :; }

src_install() {
	osinfo-db-import --root "${D}" --dir "/usr/share/osinfo" "${DISTDIR}/${A}"
}
