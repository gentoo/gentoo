# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools readme.gentoo-r1 user

DESCRIPTION="GNU package manager (nix sibling)"
HOMEPAGE="https://www.gnu.org/software/guix/"

# taken from gnu/local.mk
BOOT_GUILE=(
	"armhf-linux    20150101 guile-2.0.11.tar.xz"
	"i686-linux     20131110 guile-2.0.9.tar.xz"
	"mips64el-linux 20131110 guile-2.0.9.tar.xz"
	"x86_64-linux   20131110 guile-2.0.9.tar.xz"
)

binary_src_uris() {
	local system_date_guilep uri
	for system_date_guilep in "${BOOT_GUILE[@]}"; do
		# $1              $2       $3
		# "armhf-linux    20150101 guile-2.0.11.tar.xz"
		set -- ${system_date_guilep}
		uri="mirror://gnu-alpha/${PN}/bootstrap/$1/$2/$3"
		# ${uri} -> guix-bootstrap-armhf-linux-20150101-guile-2.0.11.tar.xz.bootstrap
		echo "${uri} -> guix-bootstrap-$1-$2-$3.bootstrap"
	done
}

# copy bootstrap binaries from DISTDIR to ${S}
copy_boot_guile_binaries() {
	local system_date_guilep
	for system_date_guilep in "${BOOT_GUILE[@]}"; do
		# $1              $2       $3
		# "armhf-linux    20150101 guile-2.0.11.tar.xz"
		set -- ${system_date_guilep}
		cp "${DISTDIR}"/guix-bootstrap-$1-$2-$3.bootstrap gnu/packages/bootstrap/$1/$3 || die
	done
}

SRC_URI="mirror://gnu-alpha/${PN}/${P}.tar.gz
	$(binary_src_uris)"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT=test # complains about size of config.log and refuses to start tests

RDEPEND="
	dev-libs/libgcrypt:0=
	>=dev-scheme/guile-2
	dev-scheme/guile-json
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
[as a user] ln -sf /var/guix/profiles/per-user/\$USER/guix-profile \$HOME/.guix-profile
[as a user] install guix packages:
	\$ guix package -i hello
[as a user] configure environment:
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
		# and add a user to /etc/group
		enewuser guixbuilder${i} -1 -1 /var/empty guixbuild,guixbuild
	done
}

src_configure() {
	# to be compatible with guix from /gnu/store
	econf \
		--localstatedir="${EPREFIX}"/var
}

src_prepare() {
	copy_boot_guile_binaries

	default

	eautoreconf
}

src_compile() {
	# guile occasionally fails with 'bad address'
	emake -j1
}

src_install() {
	# TODO: emacs highlighter
	default

	readme.gentoo_create_doc

	keepdir                /etc/guix
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
