# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 systemd toolchain-funcs

DESCRIPTION="Linux IPv6 Router Advertisement Daemon"
HOMEPAGE="https://v6web.litech.org/radvd/"
SRC_URI="https://v6web.litech.org/radvd/dist/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="selinux test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
DEPEND="
	sys-devel/bison
	sys-devel/flex
	test? ( dev-libs/check )
"
RDEPEND="
	acct-group/radvd
	acct-user/radvd
	selinux? ( sec-policy/selinux-radvd )
"

DOCS=( CHANGES README TODO radvd.conf.example )

PATCHES=(
	"${FILESDIR}"/${P}-musl-include.patch
)

src_configure() {
	econf --with-pidfile=/run/radvd/radvd.pid \
		--with-systemdsystemunitdir=no \
		$(use_with test check)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	docinto html
	dodoc INTRO.html

	newinitd "${FILESDIR}"/${PN}-2.15.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service

	readme.gentoo_create_doc
}

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Please create a configuration file ${ROOT}/etc/radvd.conf.
See ${ROOT}/usr/share/doc/${PF} for an example.

grsecurity users should allow a specific group to read /proc
and add the radvd user to that group, otherwise radvd may
segfault on startup."
