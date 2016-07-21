# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit mono multilib

MY_PN=Mono.Nat

DESCRIPTION="Mono.Nat is a C# library used for automatic port forwarding, using either uPnP or nat-pmp"
HOMEPAGE="http://projects.qnetp.net/projects/show/mono-nat"
SRC_URI="http://projects.qnetp.net/attachments/download/76/${P}.tar.gz
	mirror://gentoo/mono.snk.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=">=dev-lang/mono-2.0.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	emake -j1 ASSEMBLY_COMPILER_COMMAND="/usr/bin/gmcs -keyfile:${WORKDIR}/mono.snk"
}

src_install() {
	egacinstall $(find . -name "Mono.Nat.dll")
	dodir /usr/$(get_libdir)/pkgconfig
	ebegin "Installing .pc file"
	sed  \
		-e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PACKAGENAME@:${MY_PN}:" \
		-e "s:@DESCRIPTION@:${DESCRIPTION}:" \
		-e "s:@VERSION@:${PV}:" \
		-e 's;@LIBS@;-r:${libdir}/mono/mono-nat/Mono.Nat.dll;' \
		"${FILESDIR}"/${PN}.pc.in > "${D}"/usr/$(get_libdir)/pkgconfig/mono.nat.pc \
		|| die "sed failed"
	PKG_CONFIG_PATH="${D}/usr/$(get_libdir)/pkgconfig/" pkg-config --exists mono.nat || die ".pc file failed to validate."
	eend $?
}
