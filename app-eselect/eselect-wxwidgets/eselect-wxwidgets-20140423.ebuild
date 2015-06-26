# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-wxwidgets/eselect-wxwidgets-20140423.ebuild,v 1.4 2015/06/26 08:39:02 ago Exp $

EAPI="5"

inherit multilib

WXWRAP_VER=1.4

DESCRIPTION="Eselect module and wrappers for wxWidgets"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~ottxor/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect"

src_prepare() {
	cp "${FILESDIR}"/{wx-config,wxrc}-${WXWRAP_VER} . || die
	sed \
		-e "/^LIBDIR=/s:lib:$(get_libdir):" \
		-e "/^EPREFIX=/s:'':'${EPREFIX}':" \
		-i {wx-config,wxrc}-${WXWRAP_VER} || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins wxwidgets.eselect

	insinto /usr/share/aclocal
	newins "${FILESDIR}"/wxwin.m4-3.0 wxwin.m4

	newbin wx-config-${WXWRAP_VER} wx-config
	newbin wxrc-${WXWRAP_VER} wxrc

	keepdir /var/lib/wxwidgets
	keepdir /usr/share/bakefile/presets
}

pkg_postinst() {
	if [[ ! -e ${EROOT}/var/lib/wxwidgets/current ]]; then
		echo 'WXCONFIG="none"' > "${EROOT}"/var/lib/wxwidgets/current
	fi

	echo
	elog "This eselect module only controls the version of wxGTK used when"
	elog "building packages outside of portage.  If you are not doing development"
	elog "with wxWidgets or bakefile you will never need to use it."
	echo
}
