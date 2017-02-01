# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools readme.gentoo-r1 user

DESCRIPTION="GNU package manager (nix sibling)"
HOMEPAGE="https://www.gnu.org/software/guix/"

SRC_URI="mirror://gnu-alpha/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT=test # complains about size of config.log and refuses to start tests

RDEPEND="
	dev-libs/libgcrypt:0=
	>=dev-scheme/guile-2
	sys-libs/zlib
	app-arch/bzip2
	dev-db/sqlite
"

DEPEND="${RDEPEND}
"

QA_PREBUILT="usr/share/guile/site/2.0/gnu/packages/bootstrap/*"

PATCHES=(
	"${FILESDIR}"/${P}-no-json-crate.patch
	"${FILESDIR}"/${P}-AR.patch
)

DISABLE_AUTOFORMATTING=yes
DOC_CONTENTS="Quick start user guide on Gentoo:

[as root] allow binary substitution to be downloaded (optional)
	# guix archive --authorize < /usr/share/guix/hydra.gnu.org.pub
[as root] enable guix-daemon service:
	[systemd] # systemctl enable guix-daemon
	[openrc]  # rc-update add guix-daemon
[as an user] ln -sf /var/guix/profiles/per-user/\$USER/guix-profile \$HOME/.guix-profile
[as an user] install guix packages:
	\$ guix package -i hello
[as an user] configure environment:
	Somewhere in .bash_profile you might want to set
	export GUIX_LOCPATH=\$HOME/.guix-profile/lib/locale

Next steps:
	guix package manager user manual: https://www.gnu.org/software/guix/manual/guix.html
"

pkg_setup() {
	enewgroup guixbuild
	for i in {1..10}; do
		# we list 'guixbuild' twice to
		# both assign a primary group for user
		# and add an user to /etc/group
		enewuser guixbuilder${i} -1 -1 /var/empty guixbuild,guixbuild
	done
}

src_prepare() {
	default

	eautoreconf
}

src_install() {
	# TODO: emacs highlighter
	default

	readme.gentoo_create_doc

	# TODO: will need a tweak for prefix
	keepdir                /gnu/store
	fowners root:guixbuild /gnu/store
	fperms 1775            /gnu/store

	keepdir                /var/guix/profiles/per-user
	fperms 1777            /var/guix/profiles/per-user

	newinitd "${FILESDIR}"/guix-daemon.initd guix-daemon
}

pkg_postinst() {
	readme.gentoo_print_elog
}
