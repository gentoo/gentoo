# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson virtualx

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
	EGIT_BRANCH="develop"
	inherit git-r3
else
	SRC_URI="https://pwmt.org/projects/${PN}/download/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="UI library that focuses on simplicity and minimalism"
HOMEPAGE="https://pwmt.org/projects/girara/"

LICENSE="ZLIB"
SLOT="3"
IUSE="doc json libnotify test"

RDEPEND="
	>=dev-libs/glib-2.50
	>=x11-libs/gtk+-3.20:3
	libnotify? ( x11-libs/libnotify )
	json? ( dev-libs/json-c )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use libnotify notify)
		$(meson_use json)
		$(meson_use doc docs)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
