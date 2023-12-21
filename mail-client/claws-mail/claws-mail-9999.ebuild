# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )

inherit autotools desktop python-single-r1 xdg

DESCRIPTION="An email client (and news reader) based on GTK+"
HOMEPAGE="https://www.claws-mail.org/"

if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.claws-mail.org/readonly/claws.git"
else
	SRC_URI="https://www.claws-mail.org/download.php?file=releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

SLOT="0"
LICENSE="GPL-3"

IUSE="archive bogofilter calendar clamav dbus debug doc +gnutls +imap ldap +libcanberra +libnotify litehtml networkmanager nls nntp +notification +oauth pdf perl +pgp python rss session sieve smime spamassassin spam-report spell startup-notification svg valgrind webkit xface"
REQUIRED_USE="
	libcanberra? ( notification )
	libnotify? ( notification )
	networkmanager? ( dbus )
	oauth? ( gnutls )
	python? ( ${PYTHON_REQUIRED_USE} )
	smime? ( pgp )
"

COMMONDEPEND="
	>=dev-libs/glib-2.50:2
	dev-libs/nettle:=
	net-mail/ytnef
	sys-libs/zlib:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2[jpeg]
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	archive? (
		app-arch/libarchive
		>=net-misc/curl-7.9.7
	)
	bogofilter? ( mail-filter/bogofilter )
	calendar? (
		dev-lang/perl:=
		>=dev-libs/libical-2.0.0:=
		>=net-misc/curl-7.9.7
	)
	dbus? (
		>=dev-libs/dbus-glib-0.60
		sys-apps/dbus
	)
	gnutls? ( >=net-libs/gnutls-3.0 )
	imap? ( >=net-libs/libetpan-0.57 )
	ldap? ( >=net-nds/openldap-2.0.7:= )
	litehtml? (
		>=dev-libs/gumbo-0.10
		net-misc/curl
		media-libs/fontconfig
	)
	nls? ( >=sys-devel/gettext-0.18 )
	nntp? ( >=net-libs/libetpan-0.57 )
	notification? (
		libcanberra? (  media-libs/libcanberra[gtk3] )
		libnotify? ( x11-libs/libnotify )
	)
	perl? ( dev-lang/perl:= )
	pdf? ( app-text/poppler[cairo] )
	pgp? ( >=app-crypt/gpgme-1.0.0:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		')
	)
	rss? (
		dev-libs/libxml2
		net-misc/curl
	)
	session? (
		x11-libs/libICE
		x11-libs/libSM
	)
	smime? ( >=app-crypt/gpgme-1.0.0:= )
	spam-report? ( >=net-misc/curl-7.9.7 )
	spell? ( >=app-text/enchant-2.0.0:2= )
	startup-notification? ( x11-libs/startup-notification )
	svg? ( >=gnome-base/librsvg-2.40.5 )
	valgrind? ( dev-util/valgrind )
	webkit? ( net-libs/webkit-gtk:4.1 )
"

DEPEND="${COMMONDEPEND}
	xface? ( >=media-libs/compface-1.4 )
"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/xz-utils
	virtual/pkgconfig
"
RDEPEND="${COMMONDEPEND}
	app-misc/mime-types
	x11-misc/shared-mime-info
	clamav? ( app-antivirus/clamav )
	networkmanager? ( net-misc/networkmanager )
	pdf? ( app-text/ghostscript-gpl )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.17.5-enchant-2_default.patch"
)

src_prepare() {
	default
	sed -e "s/webkit2gtk-4.0/webkit2gtk-4.1/" -i configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-bsfilter-plugin
		--disable-dillo-plugin
		--disable-generic-umpc
		--disable-jpilot #735118
		--enable-acpi_notifier-plugin
		--enable-address_keeper-plugin
		--enable-alternate-addressbook
		--enable-att_remover-plugin
		--enable-attachwarner-plugin
		--enable-fetchinfo-plugin
		--enable-ipv6
		--enable-mailmbox-plugin
		--enable-newmail-plugin
		--enable-tnef_parse-plugin
		--with-password-encryption=$(usex gnutls gnutls old)
		$(use_enable archive archive-plugin)
		$(use_enable bogofilter bogofilter-plugin)
		$(use_enable calendar vcalendar-plugin)
		$(use_enable clamav clamd-plugin)
		$(use_enable dbus)
		$(use_enable debug crash-dialog)
		$(use_enable debug more-addressbook-debug)
		$(use_enable debug more-ldap-debug)
		$(use_enable doc manual)
		$(use_enable gnutls)
		$(use_enable ldap)
		$(use_enable litehtml litehtml_viewer-plugin)
		$(use_enable networkmanager)
		$(use_enable nls)
		$(use_enable notification notification-plugin)
		$(use_enable oauth oauth2)
		$(use_enable pdf pdf_viewer-plugin)
		$(use_enable perl perl-plugin)
		$(use_enable pgp pgpcore-plugin)
		$(use_enable pgp pgpinline-plugin)
		$(use_enable pgp pgpmime-plugin)
		$(use_enable python python-plugin)
		$(use_enable rss rssyl-plugin)
		$(use_enable session libsm)
		$(use_enable sieve managesieve-plugin)
		$(use_enable smime smime-plugin)
		$(use_enable spam-report spam_report-plugin)
		$(use_enable spamassassin spamassassin-plugin)
		$(use_enable spell enchant)
		$(use_enable startup-notification)
		$(use_enable svg)
		$(use_enable valgrind valgrind)
		$(use_enable webkit fancy-plugin)
		$(use_enable xface compface)
	)

	# libetpan is needed if user wants nntp or imap functionality
	if use imap || use nntp ; then
		myeconfargs+=( --enable-libetpan )
	else
		myeconfargs+=( --disable-libetpan )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_install() {
	local DOCS=( AUTHORS ChangeLog* INSTALL* NEWS README* TODO* )
	default

	# Makefile install claws-mail.png in /usr/share/icons/hicolor/48x48/apps
	# => also install it in /usr/share/pixmaps for other desktop envs
	# => also install higher resolution icons in /usr/share/icons/hicolor/...
	insinto /usr/share/pixmaps
	doins ${PN}.png
	local size
	for size in 64 128 ; do
		newicon -s ${size} ${PN}-${size}x${size}.png ${PN}.png
	done

	docinto tools
	dodoc tools/README*

	domenu ${PN}.desktop

	einfo "Installing extra tools"
	cd "${S}"/tools || die
	exeinto /usr/$(get_libdir)/${PN}/tools
	doexe *.pl *.py *.conf *.sh
	doexe tb2claws-mail update-po uudec uuooffice

	# kill useless files
	find "${ED}"/usr/$(get_libdir)/${PN}/plugins/ \
		\( -name "*.a" -o -name "*.la" \) -delete || die
}

pkg_postinst() {
	ewarn "When upgrading from version 3.x please re-load any plugin you use"
	xdg_pkg_postinst
}
