# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
PLOCALES="cs de it sv"

inherit python-any-r1 vala l10n toolchain-funcs multilib eutils

DESCRIPTION="free font editor which lets you create vector graphics and export TTF, EOT and SVG fonts"
HOMEPAGE="https://birdfont.org/"
SRC_URI="https://birdfont.org/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk nls"

RDEPEND="dev-db/sqlite:3
	dev-libs/libgee:0.8=
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libxmlbird
	x11-libs/gdk-pixbuf:2
	gtk? (
		net-libs/libsoup:2.4
		net-libs/webkit-gtk:3=
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/libnotify
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	nls? ( sys-devel/gettext )"

src_prepare() {
	vala_src_prepare

	epatch "${FILESDIR}"/${PN}-2.5.1-verbose.patch
	epatch "${FILESDIR}"/${PN}-2.15.5-configure-valac.patch

	sed -i \
		-e "s:pkg-config:$(tc-getPKG_CONFIG):" \
		configure dodo.py || die
}

v() {
	echo "$@"
	"$@" || die
}

src_configure() {
	# The build scripts glob all po files to see what's available.
	# Delete the files for langs we don't want to support.
	if use nls ; then
		l10n_find_plocales_changes po "" ".po" || die
		rm_locale() { rm "po/$1.po" || die ; }
		l10n_for_each_disabled_locale_do rm_locale
	else
		rm po/*.po || die
	fi

	v ./configure \
		--prefix "${EPREFIX}/usr" \
		--gtk $(usex gtk True False) \
		--gee gee-0.8 \
		--valac "${VALAC}" \
		--cc "$(tc-getCC)" \
		--cflags "${CFLAGS} ${CPPFLAGS}" \
		--ldflags "${LDFLAGS}"
}

src_compile() {
	v ./build.py
}

src_install() {
	v ./install.py \
		--dest "${D}" \
		--nogzip \
		--libdir "$(get_libdir)" \
		--manpages-directory "/share/man/man1"
	dodoc NEWS README.md
}
