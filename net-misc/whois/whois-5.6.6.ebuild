# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="Improved Whois Client"
HOMEPAGE="https://github.com/rfc1036/whois"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rfc1036/whois.git"
else
	SRC_URI="https://github.com/rfc1036/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="iconv idn nls"

RDEPEND="
	virtual/libcrypt:=
	iconv? ( virtual/libiconv )
	idn? ( net-dns/libidn2:= )
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/perl-5
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.3.0-libidn_automagic.patch
)

src_prepare() {
	default
	if ! use nls; then
		sed -i -e '/ENABLE_NLS/s:define:undef:' config.h || die
	fi
}

src_configure() { :; } # expected no-op

src_compile() {
	tc-export CC PKG_CONFIG
	local myemakeargs=(
		prefix="${EPREFIX}/usr"
		CONFIG_FILE="${EPREFIX}/etc/whois.conf"
		$(usev iconv HAVE_ICONV=1)
		$(usev idn HAVE_LIBIDN=1)
		$(usev nls LOCALEDIR=1)

		# targets
		whois
		mkpasswd
		$(usev nls pos)
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	local myemakeargs=(
		prefix="${EPREFIX}/usr"
		DESTDIR="${D}"
		BASHCOMPDIR="$(get_bashcompdir)"

		# targets
		install-whois
		install-mkpasswd
		install-bashcomp
		$(usev nls install-pos)
	)
	emake "${myemakeargs[@]}"

	insinto /etc
	doins whois.conf
	dodoc README debian/changelog
}
