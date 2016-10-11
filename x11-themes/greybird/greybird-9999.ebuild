# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	>=x11-themes/gtk-engines-murrine-0.90
	>=x11-libs/gtk+-3.20.0
"
DEPEND="${RDEPEND}
	dev-ruby/sass
	dev-libs/glib:2
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
