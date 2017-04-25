# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic readme.gentoo-r1 user

DESCRIPTION="A purely functional package manager"
HOMEPAGE="https://nixos.org/nix"

SRC_URI="http://nixos.org/releases/${PN}/${P}/${P}.tar.xz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+etc_profile +gc doc sodium"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	dev-db/sqlite
	dev-libs/openssl:0=
	net-misc/curl
	sys-libs/zlib
	gc? ( dev-libs/boehm-gc[cxx] )
	doc? ( dev-libs/libxml2
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
	)
	sodium? ( dev-libs/libsodium )
	dev-lang/perl:=
	dev-perl/DBD-SQLite
	dev-perl/WWW-Curl
	dev-perl/DBI
"
DEPEND="${RDEPEND}
	>=sys-devel/bison-2.6
	>=sys-devel/flex-2.5.35
	virtual/perl-ExtUtils-ParseXS
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11.6-systemd.patch
	"${FILESDIR}"/${PN}-1.11.6-per-user.patch
	"${FILESDIR}"/${PN}-1.11.6-respect-CXXFLAGS.patch
	"${FILESDIR}"/${PN}-1.11.6-respect-LDFLAGS.patch
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
	econf \
		--localstatedir="${EPREFIX}"/nix/var \
		$(use_enable gc)
}

src_compile() {
	local make_vars=(
		OPTIMIZE=0 # disable hardcoded -O3
		V=1 # verbose build
	)
	emake "${make_vars[@]}"
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

	keepdir             /nix/var/nix/profiles/per-user
	fperms 1777         /nix/var/nix/profiles/per-user

	doenvd "${FILESDIR}"/60nix-remote-daemon
	newinitd "${FILESDIR}"/nix-daemon.initd nix-daemon

	if ! use etc_profile; then
		rm "${ED}"/etc/profile.d/nix.sh || die
	fi
}

pkg_postinst() {
	if ! use etc_profile; then
		ewarn "${EROOT}etc/profile.d/nix.sh was removed (due to USE=-etc_profile)."
	fi

	readme.gentoo_print_elog
}
