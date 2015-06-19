# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/libnasl/libnasl-2.2.9-r1.ebuild,v 1.6 2015/03/16 06:42:41 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A remote security scanner for Linux (libnasl)"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux"
IUSE="static-libs"

RDEPEND="
	~net-analyzer/nessus-libraries-${PV}
"
DEPEND="
	${RDEPEND}
	sys-devel/bison
"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-openssl-1.patch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-bison3.patch

	sed \
		-e "/^LDFLAGS/s:$:${LDFLAGS}:g" \
		-i nasl.tmpl.in || die

	tc-export CC
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-shared
}

src_compile() {
	# emake fails for >= -j2. bug #16471.
	emake -C nasl cflags
	emake
}

src_install() {
	default
	prune_libtool_files
}
