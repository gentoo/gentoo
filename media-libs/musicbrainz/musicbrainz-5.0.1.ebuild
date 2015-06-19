# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/musicbrainz/musicbrainz-5.0.1.ebuild,v 1.9 2013/11/24 18:46:48 ago Exp $

EAPI=4
CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils

DESCRIPTION="The MusicBrainz Client Library (for accessing the latest XML based web service)"
HOMEPAGE="http://musicbrainz.org/doc/libmusicbrainz"
SRC_URI="mirror://github/metabrainz/lib${PN}/lib${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND="net-libs/neon"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"

S=${WORKDIR}/lib${P}

DOCS="AUTHORS.txt NEWS.txt README.md"

src_install() {
	cmake-utils_src_install

	if use examples; then
		docinto examples
		dodoc examples/*.{c,cc,txt}
	fi
}
