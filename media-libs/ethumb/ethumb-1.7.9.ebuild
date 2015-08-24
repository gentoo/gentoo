# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit enlightenment

DESCRIPTION="Enlightenment thumbnailing library (meant to replace epsilon)"
HOMEPAGE="https://trac.enlightenment.org/e/wiki/Ethumb"
SRC_URI="https://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus emotion static-libs"

DEPEND=">=dev-libs/eina-1.7.9
	>=dev-libs/ecore-1.7.9
	>=media-libs/edje-1.7.9
	>=media-libs/evas-1.7.9
	media-libs/libexif
	dbus? ( >=dev-libs/e_dbus-1.7.9 )
	emotion? ( >=media-libs/emotion-1.7.9 )"
RDEPEND="${DEPEND}"

src_configure() {
	E_ECONF+=(
		$(use_enable dbus ethumbd)
		$(use_enable emotion)
		--disable-epdf
	)
	enlightenment_src_configure
}
