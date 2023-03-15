# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1 systemd toolchain-funcs

DESCRIPTION="Linux IPv6 Router Advertisement Daemon"
HOMEPAGE="https://radvd.litech.org/"
SRC_URI="https://v6web.litech.org/radvd/dist/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ~ppc64 ~riscv sparc ~x86"
IUSE="selinux test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"
DEPEND="test? ( dev-libs/check )"
RDEPEND="
	acct-group/radvd
	acct-user/radvd
	selinux? ( sec-policy/selinux-radvd )"

PATCHES=(
	"${FILESDIR}"/${P}-musl-include.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	# Drop once clang16 patch is in a release
	eautoreconf
}

src_configure() {
	# Needs reentrant functions (yyset_in), bug #884375
	export LEX=flex

	econf --with-pidfile=/run/radvd/radvd.pid \
		--with-systemdsystemunitdir=no \
		$(use_with test check)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	HTML_DOCS=( INTRO.html )
	default
	dodoc radvd.conf.example

	newinitd "${FILESDIR}"/${PN}-2.15.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service

	DISABLE_AUTOFORMATTING=1
	local DOC_CONTENTS="Please create a configuration file ${EPREFIX}/etc/radvd.conf.
See ${EPREFIX}/usr/share/doc/${PF} for an example.

grsecurity users should allow a specific group to read /proc
and add the radvd user to that group, otherwise radvd may
segfault on startup."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
