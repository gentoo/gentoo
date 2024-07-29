# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic gnome2-utils

DESCRIPTION="Smart Common Input Method (SCIM) is an Input Method (IM) development platform"
HOMEPAGE="https://github.com/scim-im/scim"
SRC_URI="https://github.com/scim-im/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86"
IUSE="doc gtk3 static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/glib:2
	dev-libs/libltdl
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/libX11
	>=x11-libs/pango-1
	gtk3? ( x11-libs/gtk+:3[X] )
	!gtk3? ( x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	>=dev-util/intltool-0.33
	dev-build/libtool
	doc? (
		app-text/doxygen
		>=app-text/docbook-xsl-stylesheets-1.73.1
	)
"

DOCS=( README AUTHORS ChangeLog docs/developers docs/scim.cfg )

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.18-slibtool.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #83625
	filter-flags -fvisibility-inlines-hidden -fvisibility=hidden

	local myeconfargs=(
		--enable-ld-version-script
		$(usex gtk3 --with-gtk-version={3,2})
		$(usex !gtk3 --disable-gtk3-immodule)
		--disable-qt3-immodule
		--disable-qt4-immodule
		--without-included-libltdl
		$(use_enable static-libs static)
		$(use_enable test tests)
		$(use_with doc doxygen)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use doc && emake docs
}

src_test() {
	./tests/testlang || die "testlang failed"
	./tests/testiconvert || die "testiconvert failed"
}

src_install() {
	use doc && HTML_DOCS=( "${S}/docs/html/" )
	default
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

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
