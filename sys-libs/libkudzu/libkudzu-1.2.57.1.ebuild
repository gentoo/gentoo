# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils linux-info flag-o-matic toolchain-funcs

DESCRIPTION="Red Hat Hardware detection tools"
HOMEPAGE="https://rhlinux.redhat.com/kudzu/"
SRC_URI="mirror://gentoo/kudzu-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 -mips ppc ppc64 sparc x86"
IUSE="zlib"

DEPEND="
	dev-libs/popt
	>=sys-apps/pciutils-2.2.4[zlib?]
	zlib? ( sys-libs/zlib )
"
RDEPEND="
	${DEPEND}
	sys-apps/hwdata-gentoo
	!sys-apps/kudzu
"

S=${WORKDIR}/kudzu-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/kudzu-${PV}-sbusfix.patch \
		"${FILESDIR}"/kudzu-${PV}-sparc-keyboard.patch
}

src_configure() {
	if use zlib; then
		sed -i -e 's| -lpci| -lz -lpci|g' Makefile || die
	fi
	# Fix the modules directory to match Gentoo layout.
	sed -i -e 's|/etc/modutils/kudzu|/etc/modules.d/kudzu|g' *.* || die

	tc-export CC
}

src_compile() {
	emake \
		$( usex ppc ARCH='ppc' ARCH=$(tc-arch-kernel) ) \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB) \
		RPM_OPT_FLAGS="${CFLAGS}" \
		libkudzu.a libkudzu_loader.a
}

src_install() {
	insinto /usr/include/kudzu
	doins *.h

	dolib.a libkudzu.a libkudzu_loader.a

	keepdir /etc/sysconfig
}
