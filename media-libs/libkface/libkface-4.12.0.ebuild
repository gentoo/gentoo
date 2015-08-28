# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PV="${PV/_/-}"
MY_P="digikam-${MY_PV}"
KDE_LINGUAS=""
inherit kde4-base

DESCRIPTION="Qt/C++ wrapper around LibFace to perform face recognition and detection"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/digikam/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4/3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/opencv-2.4.9 <media-libs/opencv-3.0.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/extra/${PN}
