# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/mgorny/${PN}.git"
inherit autotools git-r3

DESCRIPTION="A system-wide notifications module for libtinynotify"
HOMEPAGE="https://github.com/mgorny/libtinynotify-systemwide/"

LICENSE="BSD"
SLOT="0"
IUSE="doc static-libs"

RDEPEND="
	sys-process/procps:0=
	x11-libs/libtinynotify:0=
"
DEPEND="
	${RDEPEND}
	>=dev-util/gtk-doc-1.18
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable doc gtk-doc)
		$(use_enable static-libs static)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
