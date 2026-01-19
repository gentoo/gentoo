# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_DEPEND_ON_PERL="no"
inherit perl-module meson

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="https://irssi.org/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	# Keep for _rc compability
	MY_P="${P/_/-}"

	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/irssi.asc
	inherit verify-sig

	SRC_URI="
		https://github.com/${PN}/${PN}/releases/download/${PV/_/-}/${MY_P}.tar.xz
		verify-sig? ( https://github.com/${PN}/${PN}/releases/download/${PV/_/-}/${MY_P}.tar.xz.asc )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

	BDEPEND=" verify-sig? ( sec-keys/openpgp-keys-irssi )"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="otr +perl selinux +proxy ${GENTOO_PERL_USESTRING}"

RDEPEND="
	>=dev-libs/glib-2.6.0
	dev-libs/openssl:=
	sys-libs/ncurses:=
	otr? (
		>=dev-libs/libgcrypt-1.2.0:=
		>=net-libs/libotr-4.1.0
	)
	perl? (
		${GENTOO_PERL_DEPSTRING}
		dev-lang/perl:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND+="
	dev-lang/perl
	virtual/pkgconfig"
RDEPEND+=" selinux? ( sec-policy/selinux-irc )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.5-perl-again.patch
)

src_configure() {
	local emesonargs=(
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
		-Dwith-perl-lib=vendor
		-Dwith-otr=$(usex otr)
		-Dwith-proxy=$(usex proxy)
		-Dwith-perl=$(usex perl)

		# Carried over from autotools (for now?), bug #677804
		-Ddisable-utf8proc=yes
		-Dwith-fuzzer=no
		-Dinstall-glib=no
	)

	meson_src_configure
}

src_test() {
	# We don't want perl-module's src_test
	meson_src_test
}

src_install() {
	meson_src_install

	use perl && perl_delete_localpod
}
