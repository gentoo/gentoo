# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils multilib toolchain-funcs

DESCRIPTION="A file manager that implements the popular two-pane design"
HOMEPAGE="http://emelfm2.net/"
SRC_URI="http://emelfm2.net/rel/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="acl gimp kernel_linux nls policykit spell udisks"

COMMON_DEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-2.12:2
	acl? ( sys-apps/acl )
	gimp? ( media-gfx/gimp )
	policykit? ( sys-auth/polkit )
	spell? ( >=app-text/gtkspell-2.0.14:2 )"
RDEPEND="${COMMON_DEPEND}
	udisks? ( sys-fs/udisks:0 )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

RESTRICT="test"

pkg_setup() {
	emel_use() {
		use ${1} && echo "${2}=1" || echo "${2}=0"
	}

	#363813
	myemelconf=(
		GTK3=0
		DOCS_VERSION=1
		$(emel_use nls I18N)
		WITH_TRANSPARENCY=1
		$(emel_use kernel_linux WITH_KERNELFAM)
		$(emel_use spell EDITOR_SPELLCHECK)
		$(emel_use udisks WITH_DEVKIT)
		$(emel_use gimp WITH_THUMBS)
		$(emel_use acl WITH_ACL)
		$(emel_use policykit WITH_POLKIT)
		STRIP=0
		)
}

src_prepare() {
	sed -i \
		-e 's:dbus-glib-1::' \
		-e 's:@$(CC):$(CC):g' \
		-e 's:@$(BIN_MSGFMT):$(BIN_MSGFMT):g' \
		Makefile || die
}

src_compile() {
	tc-export CC
	emake LIB_DIR="/usr/$(get_libdir)" PREFIX="/usr" \
		${myemelconf[@]}
}

src_install() {
	emake LIB_DIR="${D}/usr/$(get_libdir)" PREFIX="${D}/usr" \
		${myemelconf[@]} install $( use nls && echo install_i18n )
	newicon icons/${PN}_48.png ${PN}.png
}
