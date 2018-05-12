# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit git-r3 meson

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="https://www.enlightenment.org/about-terminology"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"

LICENSE="BSD-2"
SLOT="0"
IUSE="nls"

RDEPEND=">=dev-libs/efl-1.20.0[eet,fontconfig,opengl,X]"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	local emesonargs=(
		-D nls=$(usex nls true false)
	)

	meson_src_configure
}
