# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib toolchain-funcs virtualx xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="http://pwmt.org/projects/${PN}/download/${P}.tar.gz"
fi

DESCRIPTION="A highly customizable and functional document viewer"
HOMEPAGE="http://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE="+magic sqlite synctex test"

RDEPEND=">=dev-libs/girara-0.2.8:3=
	>=dev-libs/glib-2.32:2=
	x11-libs/cairo:=
	>=x11-libs/gtk+-3.6:3
	magic? ( sys-apps/file:= )
	sqlite? ( dev-db/sqlite:3= )
	synctex? ( >=app-text/texlive-core-2015 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/check )"

src_configure() {
	myzathuraconf=(
		WITH_MAGIC=$(usex magic 1 0)
		WITH_SQLITE=$(usex sqlite 1 0)
		WITH_SYNCTEX=$(usex synctex 1 0)
		PREFIX="${EPREFIX}"/usr
		LIBDIR='${PREFIX}'/$(get_libdir)
		CC="$(tc-getCC)"
		SFLAGS=''
		VERBOSE=1
		DESTDIR="${D}"
	)
}

src_compile() {
	emake "${myzathuraconf[@]}"
}

src_test() {
	virtx emake "${myzathuraconf[@]}" test
}

src_install() {
	emake "${myzathuraconf[@]}" install
	dodoc AUTHORS
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
