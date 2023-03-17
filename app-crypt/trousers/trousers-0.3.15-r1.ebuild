# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info readme.gentoo-r1 systemd udev

DESCRIPTION="An open-source TCG Software Stack (TSS) v1.1 implementation"
HOMEPAGE="http://trousers.sf.net"
SRC_URI="mirror://sourceforge/trousers/${PN}/${P}.tar.gz"

LICENSE="CPL-1.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~loong ~m68k ~ppc ppc64 ~riscv ~s390 x86"
IUSE="doc selinux" # gtk

# gtk support presently does NOT compile.
#	gtk? ( >=x11-libs/gtk+-2 )

DEPEND="acct-group/tss
	acct-user/tss
	>=dev-libs/glib-2
	>=dev-libs/openssl-0.9.7:0=
	"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-tcsd )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.3.13-nouseradd.patch"
	"${FILESDIR}/${PN}-0.3.14-Makefile.am-Mark-tddl.a-nodist.patch"
	"${FILESDIR}/${P}-tspi-drop-the-use-of-getpwent_r.patch"
)

DOCS="AUTHORS ChangeLog NICETOHAVES README TODO"

DOC_CONTENTS="
	If you have problems starting tcsd, please check permissions and
	ownership on /dev/tpm* and ~tss/system.data
"

CONFIG_CHECK="~TCG_TPM"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# econf --with-gui=$(usex gtk gtk openssl)
	econf --with-gui=openssl
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	keepdir /var/lib/tpm
	use doc && dodoc doc/*
	newinitd "${FILESDIR}"/tcsd.initd tcsd
	systemd_dounit "${FILESDIR}"/tcsd.service
	udev_dorules "${FILESDIR}"/61-trousers.rules
	fowners tss:tss /var/lib/tpm
	readme.gentoo_create_doc
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
