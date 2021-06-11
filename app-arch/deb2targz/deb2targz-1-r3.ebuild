# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Convert a .deb file to a .tar.gz archive"
HOMEPAGE="http://www.miketaylor.org.uk/tech/deb/"
SRC_URI="http://www.miketaylor.org.uk/tech/deb/${PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

RDEPEND="dev-lang/perl"

S=${WORKDIR}
PATCHES=( "${FILESDIR}/${PN}-any-data.patch" )

src_unpack() {
	cp "${DISTDIR}/${PN}" "${S}" || die
}

src_install() {
	dobin ${PN}
}
