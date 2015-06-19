# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/emelfm2/emelfm2-0.8.2.ebuild,v 1.3 2014/07/24 11:55:53 ssuominen Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="A file manager that implements the popular two-pane design"
HOMEPAGE="http://emelfm2.net/"
SRC_URI="http://emelfm2.net/rel/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="acl ansi gimp kernel_linux nls policykit spell udisks"

EMELFM2_LINGUAS=( de fr ja pl ru zh_CN )
IUSE+=" ${EMELFM2_LINGUAS[@]/#/linguas_}"

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

src_prepare() {
	sed -i \
		-e 's:dbus-glib-1::' \
		-e 's:@$(CC):$(CC):g' \
		-e 's:@$(BIN_MSGFMT):$(BIN_MSGFMT):g' \
		Makefile || die

	local lingua
	for lingua in ${EMELFM2_LINGUAS[@]}; do
		use linguas_${lingua} || mv po/${lingua}.po{,.unwanted}
	done
}

src_configure() {
	emel_use() {
		use ${1} && echo "${2}=1" || echo "${2}=0"
	}

	#363813
	myemelconf=(
		$(emel_use acl WITH_ACL)
		$(emel_use ansi WITH_OUTPUTSTYLES)
		$(emel_use gimp WITH_THUMBS)
		$(emel_use kernel_linux WITH_KERNELFAM)
		$(emel_use nls I18N)
		$(emel_use policykit WITH_POLKIT)
		$(emel_use spell EDITOR_SPELLCHECK)
		$(emel_use udisks WITH_DEVKIT)
		DOCS_VERSION=1
		GTK3=0
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
		$( use nls && echo install_i18n ) \
		install

	newicon icons/${PN}_48.png ${PN}.png
}
