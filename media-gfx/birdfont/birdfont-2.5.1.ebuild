# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PLOCALES="cs de el es fr id it nb nl oc pl pt_BR pt ru sk sr sv tr uk"

inherit python-any-r1 vala l10n toolchain-funcs multilib eutils

DESCRIPTION="free font editor which lets you create vector graphics and export TTF, EOT and SVG fonts"
HOMEPAGE="https://birdfont.org/"
SRC_URI="https://birdfont.org/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk nls"

RDEPEND="dev-libs/libgee:0.8=
	dev-libs/glib:2
	media-libs/freetype:2
	x11-libs/gdk-pixbuf:2
	gtk? (
		net-libs/libsoup:2.4
		net-libs/webkit-gtk:3=
		x11-libs/cairo
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

	# The webkit we use requires gtk 3, so fix our deps too.
	# Upstream has already made this fix for newer versions.
	sed -i \
		-e '/pkg-config/s:gtk+-2.0:gtk+-3.0:' \
		scripts/build.py || die

	sed -i \
		-e "s:pkg-config:$(tc-getPKG_CONFIG):" \
		configure scripts/{bavala,build,linux_build}.py || die

	# Respect custom valac even during configure time.
	# https://github.com/johanmattssonm/birdfont/pull/18
	sed -i \
		-e "s:valac:${VALAC}:" \
		configure || die
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

	./configure \
		--prefix "${EPREFIX}/usr" \
		--gtk $(usex gtk True False) \
		--gee gee-0.8 \
		|| die

	# Hack out gtk build when it's disabled.
	# Upstream has already fixed this for newer versions.
	use gtk || sed -i '/^build.birdfont_gtk/d' scripts/linux_build.py
}

src_compile() {
	./scripts/linux_build.py \
		--prefix "${EPREFIX}/usr" \
		--cc "$(tc-getCC)" \
		--cflags "${CFLAGS} ${CPPFLAGS}" \
		--ldflags "${LDFLAGS}" \
		--valac "${VALAC}" \
		|| die
}

src_install() {
	./install.py \
		--dest "${D}" \
		--nogzip \
		--libdir "$(get_libdir)" \
		--manpages-directory "/share/man/man1" \
		|| die
	dodoc NEWS README
}
