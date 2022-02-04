# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="Fast and simple image viewer"
HOMEPAGE="
	https://siyanpanayotov.com/project/viewnior/
	https://github.com/hellosiyan/Viewnior
"
SRC_URI="https://github.com/hellosiyan/${PN^}/archive/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	media-gfx/exiv2:0=
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"

S="${WORKDIR}/${PN^}-${P}"

PATCHES=(
	"${FILESDIR}/0.17-Replace-calls-to-getenv-with-g_getenv.patch"
	"${FILESDIR}/viewnior-0.17-update_metadata_location.patch"
)

src_prepare() {
	xdg_src_prepare

	# That script would update icon cache and desktop database.
	sed -i "s/meson.add_install_script('meson_post_install.py')//" meson.build \
		|| die 'Failed to remove post-install-script invocation from meson.build'
	# Don't let meson compress the manpage.
	sed -i "s/subdir('man')//" meson.build \
		|| die 'Failed to remove manpage compression from meson.build'
}

src_install() {
	meson_src_install
	doman man/viewnior.1
}
