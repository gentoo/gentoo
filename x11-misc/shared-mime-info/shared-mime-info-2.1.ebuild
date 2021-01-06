# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HASH=0ee50652091363ab0d17e335e5e74fbe # don't forget to update on version bumps
inherit meson xdg-utils

DESCRIPTION="The Shared MIME-info Database specification"
HOMEPAGE="https://gitlab.freedesktop.org/xdg/shared-mime-info"
SRC_URI="https://gitlab.freedesktop.org/xdg/${PN}/uploads/${HASH}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# requires installed xdgmime binary
RESTRICT="test"

BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
"
DEPEND="${RDEPEND}"

DOCS=( HACKING.md NEWS README.md )

src_install() {
	meson_src_install

	# in prefix, install an env.d entry such that prefix patch is used/added
	if use prefix; then
		echo "XDG_DATA_DIRS=\"${EPREFIX}/usr/share\"" > "${T}"/50mimeinfo || die
		doenvd "${T}"/50mimeinfo
	fi
}

pkg_postinst() {
	use prefix && export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	xdg_mimeinfo_database_update
}
