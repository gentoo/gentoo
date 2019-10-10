# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic readme.gentoo-r1 user

DESCRIPTION="A purely functional package manager"
HOMEPAGE="https://nixos.org/nix"

SRC_URI="http://nixos.org/releases/${PN}/${P}/${P}.tar.xz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+etc-profile +gc doc s3 +sodium"

# sys-apps/busybox is needed for sandbox mount of /bin/sh
RDEPEND="
	app-arch/brotli
	app-arch/bzip2
	app-arch/xz-utils
	sys-apps/busybox[static]
	dev-db/sqlite
	dev-libs/editline:0=
	dev-libs/openssl:0=
	>=dev-libs/boost-1.66:0=[context]
	net-misc/curl
	sys-libs/libseccomp
	sys-libs/zlib
	gc? ( dev-libs/boehm-gc[cxx] )
	doc? ( dev-libs/libxml2
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
	)
	s3? ( dev-libs/aws-sdk-cpp )
	sodium? ( dev-libs/libsodium:0= )
"
DEPEND="${RDEPEND}
	>=sys-devel/bison-2.6
	>=sys-devel/flex-2.5.35
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0-user-path.patch
	"${FILESDIR}"/${PN}-2.3-libpaths.patch
	"${FILESDIR}"/${PN}-2.3-bootstrap.patch
)

DISABLE_AUTOFORMATTING=yes
DOC_CONTENTS=" Quick start user guide on Gentoo:

[as root] enable nix-daemon service:
	[systemd] # systemctl enable nix-daemon
	[openrc]  # rc-update add nix-daemon
[as a user] relogin to get environment and profile update
[as a user] fetch nixpkgs update:
	\$ nix-channel --update
[as a user] install nix packages:
	\$ nix-env -i mc
[as a user] configure environment:
	Somewhere in .bash_profile you might want to set
	LOCALE_ARCHIVE=\$HOME/.nix-profile/lib/locale/locale-archive
	but please read https://github.com/NixOS/nixpkgs/issues/21820

Next steps:
	nix package manager user manual: http://nixos.org/nix/manual/
"

pkg_setup() {
	enewgroup nixbld
	for i in {1..10}; do
		# we list 'nixbld' twice to
		# both assign a primary group for user
		# and add a user to /etc/group
		enewuser nixbld${i} -1 -1 /var/empty nixbld,nixbld
	done
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	if ! use s3; then
		# Disable automagic depend: bug #670256
		export ac_cv_header_aws_s3_S3Client_h=no
	fi
	econf \
		--localstatedir="${EPREFIX}"/nix/var \
		$(use_enable gc) \
		--with-sandbox-shell=/bin/busybox
}

src_compile() {
	emake V=1
}

src_install() {
	# TODO: emacs highlighter
	default

	readme.gentoo_create_doc

	# here we use an eager variant of something that
	# is lazily done by nix-daemon and root nix-env

	# TODO: will need a tweak for prefix
	keepdir             /nix/store
	fowners root:nixbld /nix/store
	fperms 1775         /nix/store

	keepdir             /nix/var/nix/channel-cache
	fperms 0777         /nix/var/nix/channel-cache

	keepdir             /nix/var/nix/profiles/per-user
	fperms 1777         /nix/var/nix/profiles/per-user

	# setup directories nix-daemon: /etc/profile.d/nix-daemon.sh
	keepdir             /nix/var/nix/gcroots/per-user
	fperms 1777         /nix/var/nix/gcroots/per-user

	newinitd "${FILESDIR}"/nix-daemon.initd nix-daemon

	if ! use etc-profile; then
		rm "${ED}"/etc/profile.d/nix.sh || die
		rm "${ED}"/etc/profile.d/nix-daemon.sh || die
	fi
}

pkg_postinst() {
	if ! use etc-profile; then
		ewarn "${EROOT}/etc/profile.d/nix.sh was removed (due to USE=-etc-profile)."
	fi

	readme.gentoo_print_elog
}
