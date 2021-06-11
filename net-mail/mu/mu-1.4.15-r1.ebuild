# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp-common

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="https://www.djcbsoftware.nl/code/mu/ https://github.com/djcb/mu"
SRC_URI="https://github.com/djcb/mu/releases/download/${PV}/mu-${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~x64-macos"
IUSE="emacs guile mug"

DEPEND="
	dev-libs/glib:2=
	dev-libs/gmime:3.0=
	>=dev-libs/xapian-1.4:=
	emacs? ( >=app-editors/emacs-24.4:* )
	guile? ( >=dev-scheme/guile-2.2:* )
	mug? (
		net-libs/webkit-gtk:4=
		x11-libs/gtk+:3=
	)"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

SITEFILE="70mu-gentoo-autoload.el"

src_configure() {
	local myeconfargs=(
		$(use_enable emacs mu4e)
		$(use_enable mug gtk)
		$(use_enable mug webkit)
		$(use_enable guile)
	)

	econf "${myeconfargs[@]}"
}

pkg_preinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog "After upgrading from an old major version, you should"
		elog "rebuild your mail index."
	fi
}

pkg_postinst() {
	if use emacs; then
		einfo "To use mu4e you need to configure it in your .emacs file"
		einfo "See the manual for more information:"
		einfo "https://www.djcbsoftware.nl/code/mu/mu4e/"

		elisp-site-regen
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
