# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools git-r3

MY_PN=${PN/g/G}

DESCRIPTION="The default theme from Xubuntu"
HOMEPAGE="http://shimmerproject.org/project/greybird/ https://github.com/shimmerproject/Greybird"
EGIT_REPO_URI="https://github.com/shimmerproject/${MY_PN}"

# README says "dual-licensed as GPLv2 or later and CC-BY-SA 3.0 or later"
LICENSE="CC-BY-SA-3.0 GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="ayatana gnome"

RDEPEND="
	>=x11-libs/gtk+-3.22:3
	>=x11-themes/gtk-engines-murrine-0.90
"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-ruby/sass:3.5
"

src_prepare() {
	eapply_user
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install

	pushd "${ED}"usr/share/themes/${MY_PN} > /dev/null || die
	use ayatana || rm -rf unity
	use gnome || rm -rf metacity-1
	popd > /dev/null || die
}

pkg_postinst() {
	if ! has_version x11-themes/elementary-xfce-icon-theme ; then
		elog "For upstream's default icon theme, please emerge"
		elog "x11-themes/elementary-xfce-icon-theme"
	fi
	if ! has_version x11-themes/vanilla-dmz-xcursors ; then
		elog "For upstream's default cursor theme, please emerge"
		elog "x11-themes/vanilla-dmz-xcursors"
	fi
}
