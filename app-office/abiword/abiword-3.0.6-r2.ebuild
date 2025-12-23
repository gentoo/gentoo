# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit autotools flag-o-matic python-single-r1 xdg

DESCRIPTION="Fully featured yet light and fast cross platform word processor"
HOMEPAGE="https://gitlab.gnome.org/World/AbiWord"
SRC_URI="
	https://gitlab.gnome.org/World/AbiWord/-/archive/release-${PV}/AbiWord-release-${PV}.tar.bz2
	https://dev.gentoo.org/~soap/distfiles/${PN}-3.0.6-patches-r1.tar.xz"
S="${WORKDIR}/AbiWord-release-${PV}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ppc ppc64 ~riscv ~x86"
IUSE="calendar collab cups debug eds +goffice grammar +introspection latex map math +plugins readline redland spell wordperfect wmf thesaurus"
# You need 'plugins' enabled if want to enable the extra plugins
REQUIRED_USE="
	collab? ( plugins )
	grammar? ( plugins )
	introspection? ( ${PYTHON_REQUIRED_USE} )
	latex? ( plugins )
	math? ( plugins )
	readline? ( plugins )
	thesaurus? ( plugins )
	wmf? ( plugins )
	wordperfect? ( plugins )"

RDEPEND="
	>=app-text/wv-1.2
	>=dev-libs/fribidi-0.10.4
	>=dev-libs/glib-2.16:2
	>=dev-libs/libgcrypt-1.4.5:0=
	>=dev-libs/libxml2-2.4:2=
	dev-libs/libxslt
	>=gnome-base/librsvg-2.16:2
	>=gnome-extra/libgsf-1.14.18:=
	media-libs/libjpeg-turbo:=
	>=media-libs/libpng-1.2:0=
	>=x11-libs/cairo-1.10
	>=x11-libs/gtk+-3.0.8:3[cups?]
	calendar? ( >=dev-libs/libical-0.46:= )
	eds? ( >=gnome-extra/evolution-data-server-3.6.0:= )
	goffice? ( >=x11-libs/goffice-0.10.2:0.10 )
	introspection? (
		${PYTHON_DEPS}
		>=dev-libs/gobject-introspection-1.82.0-r2:=
	)
	map? ( >=media-libs/libchamplain-0.12:0.12[gtk] )
	plugins? (
		collab? (
			>=net-libs/loudmouth-1
			net-libs/libsoup:2.4
			net-libs/gnutls:=
		)
		grammar? ( >=dev-libs/link-grammar-4.2.1 )
		math? ( >=x11-libs/gtkmathview-0.7.5 )
		readline? ( sys-libs/readline:0= )
		thesaurus? ( >=app-text/aiksaurus-1.2[gtk] )
		wordperfect? (
			app-text/libwpd:0.10
			app-text/libwpg:0.3
		)
		wmf? ( >=media-libs/libwmf-0.2.8 )
	)
	redland? (
		>=dev-libs/redland-1.0.10
		>=dev-libs/rasqal-0.9.17
	)
	spell? ( app-text/enchant:2 )"
DEPEND="${RDEPEND}
	dev-libs/boost
	collab? ( dev-cpp/asio )"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig"

PATCHES=( "${WORKDIR}"/patches )

pkg_setup() {
	use introspection && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/940907
	#
	# Upstream closed as wontfix. The bug is gone due to refactoring (?) in the
	# unreleased 4.x branch. "The stable branch (3.0.x) will not get any
	# significant changes."
	filter-lto

	local plugins=()

	if use plugins; then
		# Plugins depending on libgsf
		plugins+=(t602 docbook clarisworks wml kword hancom openwriter pdf
			loadbindings mswrite garble pdb applix opendocument sdw xslfo)

		# Plugins depending on librsvg
		plugins+=(svg)

		# Plugins not depending on anything
		plugins+=(gimp bmp freetranslation iscii s5 babelfish opml eml wikipedia
			gdict passepartout google presentation urldict hrtext mif openxml)

		# inter7eps: eps.h
		# libtidy: gsf + tidy.h
		# paint: windows only ?
		plugins+=(
			$(usev collab)
			$(usev goffice)
			$(usev latex)
			$(usev math mathview)
			# psion: >=psiconv-0.9.4
			$(usev readline command)
			$(usev thesaurus aiksaurus)
			$(usev wmf)
			# wordperfect: >=wpd-0.9 >=wpg-0.2
			$(usev wordperfect wpg)
		)
	fi

	econf \
		--disable-maintainer-mode \
		--enable-plugins="${plugins[*]}" \
		--disable-default-plugins \
		--disable-builtin-plugins \
		--disable-collab-backend-telepathy \
		--enable-clipart \
		--enable-statusbar \
		--enable-templates \
		--with-gio \
		--without-gnomevfs \
		--without-gtk2 \
		$(use_enable debug) \
		$(use_with goffice goffice) \
		$(use_with calendar libical) \
		$(use_enable cups print) \
		$(use_enable collab collab-backend-xmpp) \
		$(use_enable collab collab-backend-tcp) \
		$(use_enable collab collab-backend-service) \
		$(use_with eds evolution-data-server) \
		$(use_enable introspection) \
		$(use_with map champlain) \
		$(use_with redland) \
		$(use_enable spell)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
