# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/elogviewer/elogviewer-0.6.2-r3.ebuild,v 1.5 2015/02/27 11:06:56 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="GTK+ based utility to parse the contents of elogs created by Portage"
HOMEPAGE="http://sourceforge.net/projects/elogviewer/"

SRC_URI="mirror://sourceforge/elogviewer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/portage-2.1
	>=dev-python/pygtk-2.0"

S="${WORKDIR}"

src_prepare() {
	# Apply patch from Bug 349071 to restore missing newline
	epatch "${FILESDIR}/${P}-missing_newline.patch"
	# Fix bug #453016
	sed -e 's|is not ""|!= ""|' -i elogviewer || die
}

src_install() {
	python_foreach_impl python_doscript  "${WORKDIR}"/elogviewer
	dodoc "${WORKDIR}"/CHANGELOG
	doman "${WORKDIR}"/elogviewer.1
	make_desktop_entry elogviewer Elogviewer "" "System" ||
		die "Couldn't make desktop entry"
}

pkg_postinst() {
	elog
	elog "In order to use this software, you need to activate"
	elog "Portage's elog features.  Required is"
	elog "		 PORTAGE_ELOG_SYSTEM=\"save\" "
	elog "and at least one out of "
	elog "		 PORTAGE_ELOG_CLASSES=\"warn error info log qa\""
	elog "More information on the elog system can be found"
	elog "in /etc/make.conf.example"
	elog
	elog "To operate properly this software needs the directory"
	elog "${PORT_LOGDIR:-/var/log/portage}/elog created, belonging to group portage."
	elog "To start the software as a user, add yourself to the portage"
	elog "group."
	elog
}
