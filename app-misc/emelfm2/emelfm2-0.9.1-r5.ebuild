# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EMELFM2_LINGUAS=( de fr ja pl ru zh_CN )
inherit desktop flag-o-matic toolchain-funcs xdg

DESCRIPTION="File manager that implements the popular two-pane design"
HOMEPAGE="https://emelfm2.net/ https://github.com/tom2tom/emelfm2"
SRC_URI="http://emelfm2.net/rel/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="acl ansi gimp +gtk3 kernel_linux nls policykit spell udisks"

REQUIRED_USE="spell? ( !gtk3 )"
RESTRICT="test"

DEPEND="
	>=dev-libs/glib-2.26:2
	acl? ( sys-apps/acl )
	gimp? ( media-gfx/gimp:0/2 )
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( >=x11-libs/gtk+-2.12:2 )
	policykit? ( sys-auth/polkit )
	spell? ( >=app-text/gtkspell-2.0.14:2 )
"
RDEPEND="${DEPEND}
	udisks? ( sys-fs/udisks:2 )
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	sed -i \
		-e 's:@$(BIN_MSGFMT):$(BIN_MSGFMT):g' \
		-e 's:@$(CC):$(CC):g' \
		-e 's:dbus-glib-1::' \
		Makefile || die

	local lingua
	for lingua in ${EMELFM2_LINGUAS[@]}; do
		has ${lingua} ${LINGUAS-${lingua}} || mv po/${lingua}.po{,.unwanted}
	done
}

src_configure() {
	append-cflags -fcommon

	myemelconf=(
		$(usex acl WITH_ACL=1 WITH_ACL=0)
		$(usex ansi WITH_OUTPUTSTYLES=1 WITH_OUTPUTSTYLES=0)
		$(usex gimp WITH_THUMBS=1 WITH_THUMBS=0)
		$(usex gtk3 'GTK3=1 GTK2=0' 'GTK3=0 GTK2=1')
		$(usex kernel_linux WITH_KERNELFAM=1 WITH_KERNELFAM=0)
		$(usex nls I18N=1 I18N=0)
		$(usex policykit WITH_POLKIT=1 WITH_POLKIT=0)
		$(usex spell EDITOR_SPELLCHECK=1 EDITOR_SPELLCHECK=0)
		$(usex udisks WITH_UDISKS=1 WITH_UDISKS=0)
		DOC_DIR="${EROOT}/usr/share/doc/${PF}"
		DOCS_VERSION=1
		STRIP=0
		WITH_TRANSPARENCY=1
	)
}

src_compile() {
	tc-export CC

	emake \
		${myemelconf[@]} \
		LIB_DIR="/usr/$(get_libdir)" \
		PREFIX="/usr"
}

src_install() {
	mkdir -p "${ED}/${DOC_DIR}" || die

	emake \
		${myemelconf[@]} \
		LIB_DIR="${D}/usr/$(get_libdir)" \
		PREFIX="${D}/usr" \
		XDG_DESKTOP_DIR="${D}/usr/share/applications" \
		DOC_DIR="${D}/usr/share/doc/${PF}" \
		install $(usex nls install_i18n '')

	newicon icons/${PN}_48.png ${PN}.png

	rm "${ED}"/usr/share/doc/${PF}/LGPL || die
}
