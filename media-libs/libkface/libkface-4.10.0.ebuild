# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkface/libkface-4.10.0.ebuild,v 1.1 2015/05/19 21:48:11 dilfridge Exp $

EAPI=5

MY_PV="${PV/_/-}"
MY_P="digikam-${MY_PV}"

KDE_LINGUAS=""
KDE_MINIMAL="4.10"
inherit kde4-base

DESCRIPTION="Qt/C++ wrapper around LibFace to perform face recognition and detection"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/digikam/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4/3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/opencv-2.4.9"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/extra/${PN}
