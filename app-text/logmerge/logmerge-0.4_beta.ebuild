# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/logmerge/logmerge-0.4_beta.ebuild,v 1.4 2015/04/02 17:58:31 mr_bones_ Exp $

EAPI="5"

MY_PV="${PV/_/-}"
DESCRIPTION="Merge multiple logs such that multilined entries appear in chronological order without breaks"
HOMEPAGE="https://code.google.com/p/logmerge/"
SRC_URI="https://${PN}.googlecode.com/files/${PN}-${MY_PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

DEPEND="app-arch/unzip"
RDEPEND="dev-lang/perl"

src_install() {
	dobin ${PN}
}
