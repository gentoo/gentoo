# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake xdg

DESCRIPTION="Qt GUI File Archiver"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 GPL-2+"
SLOT="0"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.2.0
"
DEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	>=dev-qt/qtbase-6.6:6[gui,widgets]
	>=x11-libs/libfm-qt-2.2:=
"
RDEPEND="${DEPEND}"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	elog "Please note that this is only a graphical front-end, and additional"
	elog "packages are needed to have support for specific file formats."
	elog "For example, to be able to work with the 7-Zip format, the"
	elog "'app-arch/p7zip' package may be used."
	elog "For the full list of supported formats, see the 'README.md' file:"
	elog "https://github.com/lxqt/lxqt-archiver/blob/master/README.md"
}
