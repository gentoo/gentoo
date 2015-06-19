# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/musicbrainz/musicbrainz-3.0.2.ebuild,v 1.11 2013/06/01 14:20:21 creffett Exp $
EAPI=5

inherit cmake-utils

DESCRIPTION="Client library to access metadata of mp3/vorbis/CD media"
HOMEPAGE="http://musicbrainz.org/"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/lib${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="net-libs/neon
	media-libs/libdiscid"

DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"

S=${WORKDIR}/lib${P}

CMAKE_IN_SOURCE_BUILD=true

DOCS="README.txt NEWS.txt AUTHORS.txt"

PATCHES=( "${FILESDIR}/${PN}-3.0.2-gcc44.patch" )
