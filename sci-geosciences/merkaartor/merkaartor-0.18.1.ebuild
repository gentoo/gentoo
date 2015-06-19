# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/merkaartor/merkaartor-0.18.1.ebuild,v 1.3 2015/03/31 13:15:04 jlec Exp $

EAPI=4

REDMINE_HASH="301"

inherit multilib qt4-r2 ${SCM_ECLASS}

DESCRIPTION="A Qt4 based map editor for the openstreetmap.org project"
HOMEPAGE="http://www.merkaartor.be"
SRC_URI="http://merkaartor.be/attachments/download/${REDMINE_HASH}/merkaartor-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
KEYWORDS="~amd64 ~x86"

IUSE="debug exif gps nls libproxy"

QT_MINIMAL="4.7.2"
DEPEND="
	>=dev-libs/boost-1.46
	>=sci-libs/gdal-1.6.0
	>=sci-libs/proj-4.6
	>=dev-qt/qtgui-${QT_MINIMAL}:4
	>=dev-qt/qtsvg-${QT_MINIMAL}:4
	>=dev-qt/qtwebkit-${QT_MINIMAL}:4
	exif? ( media-gfx/exiv2 )
	gps? ( >=sci-geosciences/gpsd-2.92[cxx] )
	libproxy? ( net-libs/libproxy )
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS CHANGELOG HACKING"

PATCHES=(
#	"${FILESDIR}"/0.17.2-includes.patch
#	"${FILESDIR}"/0.17.2-libproxy.patch
)

merkaartor_use() {
	local useflag=${1}
	[[ -z ${useflag} ]] && die "No useflag specified"
	if use ${useflag}; then
		echo "1"
	else
		echo "0"
	fi
}

src_configure() {
	local myconf
	myconf+=" RELEASE=1 ZBAR=0" # deps not in main tree so hard-disable
	myconf+=" GEOIMAGE=$(${PN}_use exif)"
	myconf+=" GPSDLIB=$(${PN}_use gps)"
	myconf+=" LIBPROXY=$(${PN}_use libproxy)"
	myconf+=" NODEBUG=$(use debug && echo "0" || echo "1")" # inverse logic
	myconf+=" NOUSEWEBKIT=0" # fails to link if disabled, upstream needs to fix
	myconf+=" TRANSDIR_MERKAARTOR=/usr/share/${PN}/translations TRANSDIR_SYSTEM=/usr/share/qt4/translations" #385671

	if use nls; then
		lrelease src/src.pro || die "lrelease failed"
	fi

	eqmake4 Merkaartor.pro LIBDIR=/usr/$(get_libdir) PREFIX=/usr/ ${myconf}
}
