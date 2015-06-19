# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/musicbrainz/musicbrainz-4.0.3.ebuild,v 1.1 2012/05/19 16:24:43 ssuominen Exp $

EAPI=4
CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils

DESCRIPTION="The MusicBrainz Client Library (for accessing the latest XML based web service)"
HOMEPAGE="http://musicbrainz.org/doc/libmusicbrainz"
SRC_URI="mirror://github/metabrainz/lib${PN}/lib${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="net-libs/neon"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"

S=${WORKDIR}/lib${P}

DOCS="AUTHORS.txt NEWS.txt README.md"
