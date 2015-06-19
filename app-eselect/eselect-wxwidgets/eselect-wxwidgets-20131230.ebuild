# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-wxwidgets/eselect-wxwidgets-20131230.ebuild,v 1.1 2015/03/31 16:58:24 ulm Exp $

EAPI="5"

WXWRAP_VER=1.3

DESCRIPTION="Eselect module and wrappers for wxWidgets"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~dirtyepic/dist/wxwidgets.eselect-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="app-admin/eselect"
S="${WORKDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${S}"/wxwidgets.eselect-${PV} wxwidgets.eselect

	insinto /usr/share/aclocal
	newins "${FILESDIR}"/wxwin.m4-3.0 wxwin.m4

	newbin "${FILESDIR}"/wx-config-${WXWRAP_VER} wx-config
	newbin "${FILESDIR}"/wxrc-${WXWRAP_VER} wxrc

	keepdir /var/lib/wxwidgets
	keepdir /usr/share/bakefile/presets
}

pkg_postinst() {
	if [[ ! -e ${ROOT}/var/lib/wxwidgets/current ]]; then
		echo 'WXCONFIG="none"' > "${ROOT}"/var/lib/wxwidgets/current
	fi

	echo
	elog "This eselect module only controls the version of wxGTK used when"
	elog "building packages outside of portage.  If you are not doing development"
	elog "with wxWidgets or bakefile you will never need to use it."
	echo
}
