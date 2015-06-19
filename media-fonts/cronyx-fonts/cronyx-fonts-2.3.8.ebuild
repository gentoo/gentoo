# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/cronyx-fonts/cronyx-fonts-2.3.8.ebuild,v 1.1 2015/02/21 16:15:03 yngwin Exp $

EAPI=5
FONT_PN="cronyx"
inherit eutils font font-ebdftopcf

MY_P="xfonts-cronyx_${PV}"
DESCRIPTION="Cronyx Cyrillic bitmap fonts for X"
HOMEPAGE="http://packages.debian.org/source/sid/xfonts-cronyx"
SRC_URI="mirror://debian/pool/main/x/xfonts-cronyx/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/x/xfonts-cronyx/${MY_P}-6.diff.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${MY_P//_/-}.orig"
FONT_S="${S}/75dpi ${S}/100dpi ${S}/misc"
DOCS="Changelog.en xcyr.README.* xrus.README"

src_prepare() {
	epatch "${WORKDIR}"/${MY_P}-6.diff
}
