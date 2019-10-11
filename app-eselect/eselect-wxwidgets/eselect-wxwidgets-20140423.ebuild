# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib

WXWRAP_VER=1.4

DESCRIPTION="Eselect module and wrappers for wxWidgets"
HOMEPAGE="https://www.gentoo.org"
SRC_URI="https://dev.gentoo.org/~junghans/dist/${P}.tar.xz
	https://dev.gentoo.org/~mgorny/dist/${PN}-files.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect"

src_prepare() {
	cp "${WORKDIR}"/eselect-wxwidgets-files/{wx-config,wxrc}-${WXWRAP_VER} . || die
	sed \
		-e "/^LIBDIR=/s:lib:$(get_libdir):" \
		-e "/^EPREFIX=/s:'':'${EPREFIX}':" \
		-i {wx-config,wxrc}-${WXWRAP_VER} || die
}

src_install() {
	insinto /usr/share/eselect/modules
	doins wxwidgets.eselect

	insinto /usr/share/aclocal
	newins "${WORKDIR}"/eselect-wxwidgets-files/wxwin.m4-3.0 wxwin.m4

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
