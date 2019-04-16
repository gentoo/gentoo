# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MPRIS plugin for mpv"
HOMEPAGE="https://github.com/hoyon/mpv-mpris"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hoyon/${PN}.git"
else
	SRC_URI="https://github.com/hoyon/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

SLOT="0"
LICENSE="MIT"
IUSE="+autoload"

BDEPEND="virtual/pkgconfig"
RDEPEND="media-video/mpv:=[cplugins,libmpv]
	dev-libs/glib"
DEPEND="${RDEPEND}"

DOCS=(
	README.md
)

src_install() {
	insinto "/usr/$(get_libdir)/mpv"
	doins mpris.so
	use autoload && dosym "/usr/$(get_libdir)/mpv/mpris.so" "/etc/mpv/scripts/mpris.so"
	einstalldocs
}

pkg_postinst() {
	if ! use autoload; then
		elog
		elog "The plugin has not been installed to /etc/mpv/scripts for autoloading."
		elog "You have to activate it manually by passing"
		elog " \"/usr/$(get_libdir)/mpv/mpris.so\" "
		elog "as script option to mpv or symlinking the library to \"scripts/\" in your mpv"
		elog "config directory."
		elog "Alternatively, activate the autoload use flag."
		elog
	fi
}
