# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

MY_P="${P^g}"

DESCRIPTION="A Unix system friendly Scheme Interpreter"
HOMEPAGE="http://practical-scheme.net/gauche/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="ipv6 test"

RDEPEND="sys-libs/gdbm"
DEPEND="${RDEPEND}
	test? ( dev-libs/openssl )"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-rpath.patch
	"${FILESDIR}"/${PN}-0.9-gauche.m4.patch
	"${FILESDIR}"/${PN}-0.9-ext-ldflags.patch
	"${FILESDIR}"/${PN}-0.9-xz-info.patch
	"${FILESDIR}"/${PN}-0.9-rfc.tls.patch
	"${FILESDIR}"/${P}-gauche.threads.patch
	"${FILESDIR}"/${P}-file.util.patch
)

src_prepare() {
	default
	eautoconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		--with-slib="${EPREFIX}"/usr/share/slib
}

src_test() {
	emake -j1 -s check
}

src_install() {
	emake -j1 DESTDIR="${D}" install-pkg install-doc
	dodoc AUTHORS ChangeLog HACKING README
}
