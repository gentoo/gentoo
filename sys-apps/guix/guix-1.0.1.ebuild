# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info readme.gentoo-r1 systemd user

DESCRIPTION="GNU package manager (nix sibling)"
HOMEPAGE="https://www.gnu.org/software/guix/"

# taken from gnu/local.mk and gnu/packages/bootstrap.scm
BOOT_GUILE=(
	"aarch64-linux  20170217 guile-2.0.14.tar.xz"
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

SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	$(binary_src_uris)"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT=test # complains about size of config.log and refuses to start tests

RDEPEND="
	dev-libs/libgcrypt:0=
	>=dev-scheme/guile-2.2:=[regex,networking,threads]
	dev-scheme/bytestructures
	dev-scheme/guile-gcrypt
	>=dev-scheme/guile-git-0.2.0
	dev-scheme/guile-json
	dev-scheme/guile-sqlite3
	net-libs/gnutls[guile]
	sys-libs/zlib
	app-arch/bzip2
	dev-db/sqlite
"

DEPEND="${RDEPEND}
"

PATCHES=("${FILESDIR}"/${PN}-0.16.0-default-daemon.patch)

QA_PREBUILT="usr/share/guile/site/*/gnu/packages/bootstrap/*"

DISABLE_AUTOFORMATTING=yes
DOC_CONTENTS="Quick start user guide on Gentoo:

[as root] allow binary substitution to be downloaded (optional)
	# guix archive --authorize < /usr/share/guix/ci.guix.info.pub
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

pkg_pretend() {
	# USER_NS is used to run builders in a default setting in linux
	# and for 'guix environment --container'.
	local CONFIG_CHECK="~USER_NS"
	check_extra_config
}

pkg_setup() {
	enewgroup guixbuild
	for i in {1..10}; do
		# we list 'guixbuild' twice to
		# both assign a primary group for user
		# and add a user to /etc/group
		enewuser guixbuilder${i} -1 -1 /var/empty guixbuild,guixbuild
	done
}

src_prepare() {
	copy_boot_guile_binaries

	default
	# build system is very eager to run automake itself: bug #625166
	eautoreconf

	# guile is trying to avoid recompilation by checking if file
	#     /usr/lib64/guile/2.2/site-ccache/guix/modules.go
	# is newer than
	#     guix/modules.scm
	# In case it is instead of using 'guix/modules.scm' guile
	# loads system one (from potentially older version of guix).
	# To work it around we bump last modification timestamp of
	# '*.scm' files.
	find "${S}" -name "*.scm" -exec touch {} + || die

	# Gentoo stores systemd unit files in lib, never in lib64: bug #689772
	sed -i nix/local.mk \
		-e 's|systemdservicedir = $(libdir)/systemd/system|systemdservicedir = '"$(systemd_get_systemunitdir)"'|' || die
}

src_configure() {
	# to be compatible with guix from /gnu/store
	econf \
		--localstatedir="${EPREFIX}"/var
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
