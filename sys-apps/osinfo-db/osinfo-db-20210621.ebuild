# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="osinfo database files"
HOMEPAGE="https://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.xz"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

BDEPEND="sys-apps/osinfo-db-tools"

# we don't depend on intltool here, contrary to README, as the tarball already
# contains the processed results with translations in XML files

src_unpack() { :; }

src_install() {
	osinfo-db-import --root "${D}" --dir "/usr/share/osinfo" "${DISTDIR}/${A}"
}
