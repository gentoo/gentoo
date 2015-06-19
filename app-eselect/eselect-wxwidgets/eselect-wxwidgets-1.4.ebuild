# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-wxwidgets/eselect-wxwidgets-1.4.ebuild,v 1.1 2015/03/31 16:58:24 ulm Exp $

WXWRAP_VER=1.3
WXESELECT_VER=1.4

DESCRIPTION="Eselect module and wrappers for wxWidgets"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/wxwidgets.eselect-${WXESELECT_VER}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="!<=x11-libs/wxGTK-2.6.4.0-r2"
RDEPEND=">=app-admin/eselect-1.2.3"

S=${WORKDIR}

src_install() {
	insinto /usr/share/eselect/modules
	newins "${S}"/wxwidgets.eselect-${WXESELECT_VER} wxwidgets.eselect \
		|| die "Failed installing module"

	insinto /usr/share/aclocal
	newins "${FILESDIR}"/wxwin.m4-2.9 wxwin.m4 || die "Failed installing m4"

	newbin "${FILESDIR}"/wx-config-${WXWRAP_VER} wx-config \
		|| die "Failed installing wx-config"
	newbin "${FILESDIR}"/wxrc-${WXWRAP_VER} wxrc \
		|| die "Failed installing wxrc"

	keepdir /var/lib/wxwidgets
	keepdir /usr/share/bakefile/presets
}

pkg_postinst() {
	if [[ ! -e ${ROOT}/var/lib/wxwidgets/current ]]; then
		echo 'WXCONFIG="none"' > "${ROOT}"/var/lib/wxwidgets/current
	fi

	echo
	elog "By default the system wxWidgets profile is set to \"none\"."
	elog
	elog "It is unnecessary to change this unless you are doing development work"
	elog "with wxGTK outside of portage.  The package manager ignores the profile"
	elog "setting altogether."
	echo
}
