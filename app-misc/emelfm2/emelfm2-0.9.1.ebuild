# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/emelfm2/emelfm2-0.9.1.ebuild,v 1.2 2014/07/24 11:55:53 ssuominen Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="A file manager that implements the popular two-pane design"
HOMEPAGE="http://emelfm2.net/"
SRC_URI="http://emelfm2.net/rel/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="acl ansi gimp gtk3 kernel_linux nls policykit spell udisks"

EMELFM2_LINGUAS=( de fr ja pl ru zh_CN )
IUSE+=" ${EMELFM2_LINGUAS[@]/#/linguas_}"

COMMON_DEPEND="
	>=dev-libs/glib-2.26:2
	!gtk3? ( >=x11-libs/gtk+-2.12:2 )
	gtk3? ( x11-libs/gtk+:3 )
	acl? ( sys-apps/acl )
	gimp? ( media-gfx/gimp )
	policykit? ( sys-auth/polkit )
	spell? ( >=app-text/gtkspell-2.0.14:2 )
"
RDEPEND="
	${COMMON_DEPEND}
	udisks? ( sys-fs/udisks:0 )
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

RESTRICT="test"

src_prepare() {
	sed -i \
		-e 's:@$(BIN_MSGFMT):$(BIN_MSGFMT):g' \
		-e 's:@$(CC):$(CC):g' \
		-e 's:dbus-glib-1::' \
		Makefile || die

	local lingua
	for lingua in ${EMELFM2_LINGUAS[@]}; do
		use linguas_${lingua} || mv po/${lingua}.po{,.unwanted}
	done
}

src_configure() {
	myemelconf=(
		$(usex acl WITH_ACL=1 WITH_ACL=0)
		$(usex ansi WITH_OUTPUTSTYLES=1 WITH_OUTPUTSTYLES=0)
		$(usex gimp WITH_THUMBS=1 WITH_THUMBS=0)
		$(usex gtk3 'GTK3=1 GTK2=0' 'GTK3=0 GTK2=1')
		$(usex kernel_linux WITH_KERNELFAM=1 WITH_KERNELFAM=0)
		$(usex nls I18N=1 I18N=0)
		$(usex policykit WITH_POLKIT=1 WITH_POLKIT=0)
		$(usex spell EDITOR_SPELLCHECK=1 EDITOR_SPELLCHECK=0)
		$(usex udisks WITH_DEVKIT=1 WITH_DEVKIT=0)
		DOCS_VERSION=1
		STRIP=0
		WITH_TRANSPARENCY=1
	)
}

src_compile() {
	tc-export CC
	emake \
		LIB_DIR="/usr/$(get_libdir)" \
		PREFIX="/usr" \
		${myemelconf[@]}
}

src_install() {
	emake \
		LIB_DIR="${D}/usr/$(get_libdir)" \
		PREFIX="${D}/usr" \
		${myemelconf[@]} \
		install \
		$(usex nls install_i18n '')

	newicon icons/${PN}_48.png ${PN}.png
}
