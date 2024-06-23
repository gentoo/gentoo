# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd tmpfiles

DESCRIPTION="Operating system and container binary deployment and upgrades"
HOMEPAGE="https://ostreedev.github.io/ostree/"
SRC_URI="
	https://github.com/ostreedev/ostree/releases/download/v${PV}/lib${P}.tar.xz
		-> ${P}.tar.xz
"
S="${WORKDIR}/lib${P}"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
LICENSE="LGPL-2+"
SLOT="0"

IUSE="archive +curl doc dracut gnutls +gpg grub +http2 httpd introspection libmount selinux sodium ssl +soup systemd zeroconf"
RESTRICT="test"
REQUIRED_USE="
	dracut? ( systemd )
	http2? ( curl )
	httpd? ( || ( curl soup ) )
"

RDEPEND="
	app-arch/xz-utils
	dev-libs/libassuan:=
	dev-libs/glib:2
	sys-fs/fuse:3
	sys-libs/zlib
	archive? ( app-arch/libarchive:= )
	curl? ( net-misc/curl )
	dracut? ( sys-kernel/dracut )
	gpg? (
		app-crypt/gpgme:=
		dev-libs/libgpg-error
	)
	grub? ( sys-boot/grub:2= )
	introspection? ( dev-libs/gobject-introspection )
	libmount? ( sys-apps/util-linux )
	selinux? ( sys-libs/libselinux )
	sodium? ( >=dev-libs/libsodium-1.0.14:= )
	soup? ( net-libs/libsoup:2.4 )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? (
			dev-libs/openssl:0=
		)
	)
	systemd? ( sys-apps/systemd:0= )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	doc? ( dev-util/gtk-doc )
"
BDEPEND="
	dev-util/glib-utils
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/ostree-2023.3-libgpg-error-underlinked-lld.patch
	"${FILESDIR}"/ostree-2023.3-dont-force-clang-introspection.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Needs Bison (bug #884289)
	unset YACC

	local econfargs=(
		--enable-man
		--enable-shared
		--with-grub2-mkconfig-path=grub-mkconfig
		--with-modern-grub
		$(use_with archive libarchive)
		$(use_with curl)
		$(use_with dracut dracut yesbutnoconf) #816867
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
		econfargs+=( --with-systemdsystemunitdir="$(systemd_get_systemunitdir)" )
	fi

	unset ${!XDG_*} #657346 g-ir-scanner sandbox violation
	econf "${econfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	tmpfiles_process ostree-tmpfiles.conf
}
