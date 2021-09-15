# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Operating system and container binary deployment and upgrades"
HOMEPAGE="https://ostreedev.github.io/ostree/"
SRC_URI="https://github.com/ostreedev/ostree/releases/download/v${PV}/lib${P}.tar.xz -> ${P}.tar.xz"

KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
LICENSE="LGPL-2+"
SLOT="0"

IUSE="archive curl doc dracut gnutls +gpg grub http2 httpd introspection libmount selinux sodium ssl +soup systemd zeroconf"
RESTRICT="test"
REQUIRED_USE="httpd? ( || ( curl soup ) )"

COMMON_DEPEND="
	archive? ( app-arch/libarchive:= )
	app-arch/xz-utils
	curl? ( net-misc/curl )
	soup? ( net-libs/libsoup )
	dev-libs/libassuan
	dev-libs/glib:2
	dracut? ( sys-kernel/dracut )
	gpg? (
		app-crypt/gpgme
		dev-libs/libgpg-error
	)
	grub? ( sys-boot/grub:2= )
	introspection? ( dev-libs/gobject-introspection )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? (
			dev-libs/openssl:0=
		)
	)
	>=sys-fs/fuse-2.9.2:0
	sys-libs/zlib
	libmount? ( sys-apps/util-linux )
	selinux? ( sys-libs/libselinux )
	sodium? ( >=dev-libs/libsodium-1.0.14:= )
	systemd? ( sys-apps/systemd:0= )
	zeroconf? ( net-dns/avahi[dbus] )"

DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	doc? ( dev-util/gtk-doc )"

RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	dev-util/glib-utils
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig"

S="${WORKDIR}/lib${P}"

src_prepare() {
	sed -Ee 's:(XSLT_STYLESHEET = ).*:\1/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl:' \
		-i Makefile.in Makefile-man.am || die
	eautoreconf
	default
}

src_configure() {
	local econfargs=(
		--enable-man
		--enable-shared
		$(use_with archive libarchive)
		$(use_with curl)
		$(use_with dracut)
		$(use_enable doc gtk-doc)
		$(usex introspection --enable-introspection={,} yes no)
		$(use_with gpg gpgme)
		$(use_enable http2)
		$(use_enable httpd trivial-httpd-cmdline)
		$(use_with selinux )
		$(use_with soup)
		$(use_with libmount)
		$(use ssl && { use gnutls && echo --with-crypto=gnutls || echo --with-crypto=openssl; })
		$(use_with sodium ed25519-libsodium)
		$(use_with systemd libsystemd)
		$(use_with zeroconf avahi)
	)

	if use systemd; then
		econfargs+=(--with-systemdsystemunitdir="$(systemd_get_systemunitdir)")
	fi

	unset ${!XDG_*} #657346 g-ir-scanner sandbox violation
	econf ${econfargs[*]}
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	rm -f "${ED}/etc/grub.d/15_ostree"
}
