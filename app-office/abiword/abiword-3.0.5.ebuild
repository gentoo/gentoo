# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Fully featured yet light and fast cross platform word processor"
HOMEPAGE="http://www.abisource.com/"
SRC_URI="
	http://www.abisource.com/downloads/${PN}/${PV}/source/${P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${PN}-3.0.4-patchset-r3.txz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="calendar collab cups debug eds +goffice grammar +introspection latex map math ots +plugins readline redland spell wordperfect wmf thesaurus"
# You need 'plugins' enabled if want to enable the extra plugins
REQUIRED_USE="
	collab? ( plugins )
	grammar? ( plugins )
	latex? ( plugins )
	math? ( plugins )
	ots? ( plugins )
	readline? ( plugins )
	thesaurus? ( plugins )
	wordperfect? ( plugins )
	wmf? ( plugins )"

RDEPEND="
	>=app-text/wv-1.2
	>=dev-libs/fribidi-0.10.4
	>=dev-libs/glib-2.16:2
	>=dev-libs/libgcrypt-1.4.5:0=
	dev-libs/libxslt
	>=gnome-base/librsvg-2.16:2
	>=gnome-extra/libgsf-1.14.18:=
	>=media-libs/libpng-1.2:0=
	virtual/jpeg:0
	>=x11-libs/cairo-1.10
	>=x11-libs/gtk+-3.0.8:3[cups?]
	calendar? ( >=dev-libs/libical-0.46:= )
	eds? ( >=gnome-extra/evolution-data-server-3.6.0:= )
	goffice? ( >=x11-libs/goffice-0.10.2:0.10 )
	introspection? ( >=dev-libs/gobject-introspection-1.0.0:= )
	map? ( >=media-libs/libchamplain-0.12:0.12[gtk] )
	plugins? (
		collab? (
			>=dev-libs/libxml2-2.4:2
			>=net-libs/loudmouth-1
			net-libs/libsoup:2.4
			net-libs/gnutls:=
		)
		grammar? ( >=dev-libs/link-grammar-4.2.1 )
		math? ( >=x11-libs/gtkmathview-0.7.5 )
		ots? ( >=app-text/ots-0.5-r1 )
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
	spell? ( app-text/enchant:2 )
	!<app-office/abiword-plugins-2.8"
DEPEND="${RDEPEND}
	dev-libs/boost
	collab? ( dev-cpp/asio )"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}"/patches/${PN}-2.6.0-boolean.patch
	"${WORKDIR}"/patches/${PN}-2.8.3-desktop.patch
	"${WORKDIR}"/patches/${PN}-3.0.0-librevenge.patch
	"${WORKDIR}"/patches/${PN}-3.0.2-explicit-python.patch
	"${WORKDIR}"/patches/${PN}-3.0.4-enchant-2.patch # backport
	"${WORKDIR}"/patches/${PN}-3.0.4-pygobject.patch
	"${WORKDIR}"/patches/${PN}-3.0.4-asio-standalone-placeholders.patch
	"${WORKDIR}"/patches/${PN}-3.0.4-c++17-dynamic-exception-specifications.patch
	"${FILESDIR}"/${PN}-3.0.5-musl-lose-precision-fix.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
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
		use collab && plugins+=(collab)
		use goffice && plugins+=(goffice)
		use latex && plugins+=(latex)
		use math && plugins+=(mathview)
		use ots && plugins+=(ots)
		# psion: >=psiconv-0.9.4
		use readline && plugins+=(command)
		use thesaurus && plugins+=(aiksaurus)
		use wmf && plugins+=(wmf)
		# wordperfect: >=wpd-0.9 >=wpg-0.2
		use wordperfect && plugins+=(wpg)
	fi

	econf \
		--disable-maintainer-mode \
		--enable-plugins="${plugins[*]}" \
		--disable-static \
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
