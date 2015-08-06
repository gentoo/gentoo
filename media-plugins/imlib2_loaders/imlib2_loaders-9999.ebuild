# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/imlib2_loaders/imlib2_loaders-9999.ebuild,v 1.1 2015/08/06 10:25:32 vapier Exp $

EAPI="5"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
else
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="image loader plugins for Imlib 2"
HOMEPAGE="http://www.enlightenment.org/pages/imlib2.html"

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
