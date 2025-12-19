# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

WXWRAP_VER=1.4

DESCRIPTION="Eselect module and wrappers for wxWidgets"
HOMEPAGE="https://gitweb.gentoo.org/proj/eselect-wxwidgets.git/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/app-eselect/eselect-wxwidgets/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND=">=app-admin/eselect-1.4.13"

src_prepare() {
	sed \
		-e "/^LIBDIR=/s:lib:$(get_libdir):" \
		-e "/^EPREFIX=/s:'':'${EPREFIX}':" \
		-i {wx-config,wxrc}-"${WXWRAP_VER}" || die
	eapply_user
}

src_install() {
	insinto /usr/share/eselect/modules
	doins wxwidgets.eselect

	insinto /usr/share/aclocal
	newins wxwin.m4-3.0 wxwin.m4

	newbin "wx-config-${WXWRAP_VER}" wx-config
	newbin "wxrc-${WXWRAP_VER}" wxrc

	keepdir /var/lib/wxwidgets
	keepdir /usr/share/bakefile/presets
}

pkg_postinst() {
	if [[ ! -e ${EROOT}/var/lib/wxwidgets/current ]]; then
		echo 'WXCONFIG="none"' > "${EROOT}"/var/lib/wxwidgets/current
	fi

	elog "This eselect module only controls the version of wxGTK used when"
	elog "building packages outside of portage.  If you are not doing development"
	elog "with wxWidgets or bakefile you will never need to use it."
}
