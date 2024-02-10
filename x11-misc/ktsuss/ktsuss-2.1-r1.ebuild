# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Graphical version of su written in C and GTK+ 2"
HOMEPAGE="https://github.com/nomius/ktsuss/"
SRC_URI="https://github.com/nomius/ktsuss/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86"
IUSE="sudo"

RDEPEND="
	x11-libs/gtk+:2
	dev-libs/glib:2
	sudo? ( app-admin/sudo )
	!sudo? (
		|| (
			sys-apps/util-linux[su]
			sys-apps/shadow[su]
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( Changelog CREDITS README.md )

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
	"${FILESDIR}"/${P}-no-which.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable sudo)
}
