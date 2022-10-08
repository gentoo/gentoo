# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Linux Point-to-Point Tunnelling Protocol Server"
HOMEPAGE="http://poptop.sourceforge.net/"
SRC_URI="mirror://sourceforge/poptop/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="gre-extreme-debug tcpd"

RDEPEND="net-dialup/ppp:=
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
	elibc_musl? ( net-libs/ppp-defs )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
	"${FILESDIR}/${P}-sandbox-fix.patch"
	"${FILESDIR}/${P}-pidfile.patch"
	"${FILESDIR}/${P}-libdir.patch"
	"${FILESDIR}/${P}-musl.patch"
)

src_prepare() {
	# Match pptpd-logwtmp.so's version with pppd's version (#89895)
	local PPPD_VER=$(best_version net-dialup/ppp)
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
	sed -i -e "s:\\(#define[ \\t]*VERSION[ \\t]*\\)\".*\":\\1\"${PPPD_VER}\":" plugins/patchlevel.h || die

	# configure.in is actually configure.ac
	mv configure.in configure.ac || die

	# Automake 1.13 compatibility, bug #469476
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADER/' configure.ac || die 'sed on configure.ac failed'

	# remove 'missing' script to prevent warnings
	rm missing || die 'remove missing script failed'

	# respect compiler, bug #461722
	tc-export CC

	# Call to default src_prepare to apply patches
	default

	eautoreconf
}

src_configure() {
	use gre-extreme-debug && append-cppflags "-DLOG_DEBUG_GRE_ACCEPTING_PACKET"
	econf \
		--enable-bcrelay \
		$(use tcpd && echo "--with-libwrap")
}

src_compile() {
	emake COPTS="${CFLAGS}"
}

src_install() {
	default

	insinto /etc
	doins samples/pptpd.conf

	insinto /etc/ppp
	doins samples/options.pptpd

	newinitd "${FILESDIR}/pptpd-init-r2" pptpd
	newconfd "${FILESDIR}/pptpd-confd" pptpd

	dodoc README.*
	dodoc -r samples
}
