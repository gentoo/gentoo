# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic multilib gnome2-utils autotools

DESCRIPTION="Smart Common Input Method (SCIM) is an Input Method (IM) development platform"
HOMEPAGE="https://sourceforge.net/projects/scim"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc ~x86 ~x86-fbsd"
IUSE="doc gtk3"

RDEPEND="x11-libs/libX11
	dev-libs/glib:2
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	>=dev-libs/atk-1
	>=x11-libs/pango-1"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen
		>=app-text/docbook-xsl-stylesheets-1.73.1 )
	dev-lang/perl
	virtual/pkgconfig
	>=dev-util/intltool-0.33
	sys-devel/libtool"
DOCS=(
	README
	AUTHORS
	ChangeLog
	docs/developers
	docs/scim.cfg
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #83625
	filter-flags -fvisibility-inlines-hidden -fvisibility=hidden
	econf $(use_with doc doxygen) \
		--enable-ld-version-script \
		$(usex gtk3 --with-gtk-version={3,2})
}

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	use doc && HTML_DOCS=( "${S}/docs/html/" )
	default

	sed -e "s:@EPREFIX@:${EPREFIX}:" "${FILESDIR}/xinput-${PN}" > "${T}/${PN}.conf" || die
	insinto /etc/X11/xinit/xinput.d
	doins "${T}/${PN}.conf"
}

pkg_postinst() {
	elog
	elog "To use SCIM with both GTK and XIM, you should use the following"
	elog "in your user startup scripts such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog "export GTK_IM_MODULE=\"scim\""
	elog "export QT_IM_MODULE=\"scim\""
	elog
	elog "where 'your_language' can be zh_CN, zh_TW, ja_JP.eucJP or any other"
	elog "UTF-8 locale such as en_US.UTF-8 or ja_JP.UTF-8"
	elog
	elog "To use Chinese input methods:"
	elog "	# emerge app-i18n/scim-tables app-i18n/scim-pinyin"
	elog "To use Korean input methods:"
	elog "	# emerge app-i18n/scim-hangul"
	elog "To use Japanese input methods:"
	elog "	# emerge app-i18n/scim-anthy"
	elog "To use various input methods (more than 30 languages):"
	elog "	# emerge app-i18n/scim-m17n"
	elog
	elog "Please modify ${EPREFIX}/etc/scim/global and add your UTF-8 locale to"
	elog "/SupportedUnicodeLocales entry."
	elog
	ewarn
	ewarn "If you upgraded from scim-1.2.x or scim-1.0.x, you should remerge all SCIM modules."
	ewarn

	gnome2_query_immodules_gtk2
}

pkg_postrm() {
	gnome2_query_immodules_gtk2
}
