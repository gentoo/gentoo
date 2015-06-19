# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/retrovol/retrovol-0.12.ebuild,v 1.1 2012/10/03 05:47:56 yngwin Exp $

EAPI=4
PLOCALES="de fr"
inherit base l10n

DESCRIPTION="Systemtray volume mixer applet from PuppyLinux"
HOMEPAGE="http://puppylinux.org/wikka/Retrovol"
SRC_URI="http://www.browserloadofcoolness.com/software/puppy/PETget/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS="ChangeLog README TODO"

src_prepare() {
	# Check for locales added/removed from previous version
	l10n_find_plocales_changes "po" "" '.po'

	base_src_prepare
}

src_configure() {
	econf $(use_enable nls)
}

pkg_postinst() {
	echo
	elog "You can find a sample configuration file at"
	elog "   ${ROOT%/}/usr/share/retrovol/dot.retrovolrc"
	elog "To customize, copy it to ~/.retrovolrc and edit it as you like"
	echo
}
