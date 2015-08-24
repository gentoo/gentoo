# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
else
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="image loader plugins for Imlib 2"
HOMEPAGE="https://www.enlightenment.org/pages/imlib2.html"

IUSE="eet xcf"

RDEPEND=">=media-libs/imlib2-${PV}
	eet? ( dev-libs/eet )"

src_configure() {
	E_ECONF=(
		$(use_enable eet)
		$(use_enable xcf)
	)

	enlightenment_src_configure
}
