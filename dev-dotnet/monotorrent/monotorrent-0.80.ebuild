# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit mono multilib

DESCRIPTION="Monotorrent is an open source C# bittorrent library"
HOMEPAGE="http://projects.qnetp.net/projects/show/monotorrent"
SRC_URI="http://projects.qnetp.net/attachments/download/28/${P}.tar.gz
	mirror://gentoo/mono.snk.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=">=dev-lang/mono-2.0.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# The hack we do to get the dll installed in the GAC makes the unit-tests
# defunct.
RESTRICT="test"

src_prepare() {
	sed -i	\
		-e "/InternalsVisibleTo/d" \
		MonoTorrent/AssemblyInfo.cs* || die
}

src_compile() {
	emake -j1 ASSEMBLY_COMPILER_COMMAND="/usr/bin/gmcs -keyfile:${WORKDIR}/mono.snk"
}

src_install() {
	egacinstall $(find . -name "MonoTorrent.dll")
	dodir /usr/$(get_libdir)/pkgconfig
	ebegin "Installing .pc file"
	sed  \
		-e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PACKAGENAME@:${PN}:" \
		-e "s:@DESCRIPTION@:${DESCRIPTION}:" \
		-e "s:@VERSION@:${PV}:" \
		-e 's;@LIBS@;-r:${libdir}/mono/monotorrent/MonoTorrent.dll;' \
		"${FILESDIR}"/${PN}.pc.in > "${D}"/usr/$(get_libdir)/pkgconfig/${PN}.pc
	PKG_CONFIG_PATH="${D}/usr/$(get_libdir)/pkgconfig/" pkg-config --exists monotorrent || die ".pc file failed to validate."
	eend $?
}
