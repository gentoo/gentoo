# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Fast and simple image viewer"
HOMEPAGE="https://siyanpanayotov.com/project/viewnior https://github.com/BwackNinja/Viewnior"
COMMIT="420f08a5f47a2fc1ae476615bab93df3478ba078"
SRC_URI="https://github.com/BwackNinja/Viewnior/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Viewnior-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	dev-libs/glib:2
	media-gfx/exiv2:0=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8-change-exiv2-AutoPtr-to-unique_ptr.patch
	"${FILESDIR}"/${PN}-1.8-add-support-for-exiv-0.28.0-errors.patch
)

src_prepare() {
	# That script would update icon cache and desktop database.
	sed -i "s/meson.add_install_script('meson_post_install.py')//" meson.build \
		|| die 'Failed to remove post-install-script invocation from meson.build'
	# Don't let meson compress the manpage.
	sed -i "s/subdir('man')//" meson.build \
		|| die 'Failed to remove manpage compression from meson.build'

	default
}

src_install() {
	meson_src_install
	doman man/viewnior.1
}
