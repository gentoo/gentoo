# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )
PLOCALES="cs de it nl pt_BR sv"

inherit python-any-r1 vala l10n toolchain-funcs multiprocessing

DESCRIPTION="Font editor for the creation of vector graphics and export TTF, EOT & SVG fonts"
HOMEPAGE="https://birdfont.org/"
SRC_URI="https://birdfont.org/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk nls"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/libgee:0.8=
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libxmlbird
	x11-libs/gdk-pixbuf:2
	gtk? (
		net-libs/libsoup:2.4
		net-libs/webkit-gtk:4=
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/libnotify
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/doit[${PYTHON_USEDEP}]')
	$(vala_depend)
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	vala_src_prepare
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
	v doit run -n $(makeopts_jobs)
}

src_install() {
	v ./install.py \
		--dest "${D}" \
		--nogzip \
		--libdir "$(get_libdir)" \
		--manpages-directory "/share/man/man1"
	einstalldocs
}
