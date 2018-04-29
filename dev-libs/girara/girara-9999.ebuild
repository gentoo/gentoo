# Copyright 1999-2018 Gentoo Authors
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
SLOT="0"
IUSE="doc json libnotify test"

RDEPEND="
	>=dev-libs/glib-2.50
	>=x11-libs/gtk+-3.20:3
	>=x11-libs/pango-1.14
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	json? ( dev-libs/json-c )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	test? ( dev-libs/check )
	doc? ( app-doc/doxygen )
"

src_configure() {
	local emesonargs=(
		-Denable-notify=$(usex libnotify true false)
		-Denable-json=$(usex json true false)
		-Denable-docs=$(usex doc true false)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	if use doc; then
		HTML_DOCS="${BUILD_DIR}/doc/html/."
	fi
	meson_src_install
}
