# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson virtualx xdg

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
	EGIT_BRANCH="develop"
	inherit git-r3
else
	SRC_URI="https://pwmt.org/projects/${PN}/download/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="A highly customizable and functional document viewer"
HOMEPAGE="http://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE="doc +magic +seccomp sqlite synctex test"

RDEPEND="
	>=x11-libs/gtk+-3.22:3
	>=dev-libs/glib-2.50:2=
	>=dev-libs/girara-0.2.9:3=
	sqlite? ( dev-db/sqlite:3= )
	magic? ( sys-apps/file:= )
	synctex? ( >=app-text/texlive-core-2015 )
	seccomp? ( sys-libs/libseccomp )
	doc? (
		dev-python/sphinx
		dev-python/sphinx_rtd_theme
		app-doc/doxygen
		dev-python/breathe
	)
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	test? ( dev-libs/check )"

src_configure() {
	local emesonargs=(
		-Denable-sqlite=$(usex sqlite true false)
		-Denable-synctex=$(usex synctex true false)
		-Denable-magic=$(usex magic true false)
		-Denable-seccomp=$(usex seccomp true false)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
