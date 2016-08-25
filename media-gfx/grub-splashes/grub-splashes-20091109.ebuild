# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mount-boot

DESCRIPTION="Collection of grub splashes"
HOMEPAGE="https://dev.gentoo.org/~welp/grub-splashes.xml"
SRC_URI="mirror://gentoo/${PN}-0.1.tar.gz
	http://www.kde-look.org/CONTENT/content-files/49074-natural_gentoo-8.0.tar.gz
	http://www.kde-look.org/CONTENT/content-files/98478-gentoo-splash.xpm.gz"

LICENSE="GPL-2 Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${DISTDIR}"/98478-gentoo-splash.xpm.gz gentoo-blue.xpm.gz
}

src_install() {
	insinto /boot/grub
	find . -name '*.xpm.gz' -exec doins {} \;
}

pkg_postinst() {
	elog "Please note that this ebuild makes the assumption that you're"
	elog "using /boot/grub/ for your grub configuration."
	elog ""
	elog "To use your new grub splashes edit your /boot/grub/grub.conf"
	elog "You can see available splash screens by running"
	elog "\`ls /boot/grub/ | grep xpm\`"
}
