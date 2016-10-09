# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono multilib versionator

DESCRIPTION="Nini - A configuration library for .NET"
HOMEPAGE="http://nini.sourceforge.net"
SRC_URI="mirror://sourceforge/nini/Nini-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-2"
DEPEND="${RDEPEND}
	app-arch/sharutils
"

S="${WORKDIR}/Nini/Source"

src_prepare() {
	uudecode -o Nini.snk "${FILESDIR}"/Nini.snk.uue || die
}

src_configure() {
	use debug && DEBUG="-debug"
}

src_compile() {
	#See nini in Debian for info
	mcs	${DEBUG} \
		-nowarn:1616 \
		-target:library \
		-out:Nini.dll \
		-define:STRONG \
		-r:System.dll \
		-r:System.Xml.dll \
		-keyfile:Nini.snk \
		AssemblyInfo.cs Config/*.cs Ini/*.cs Util/*.cs \
		|| die "Compilation failed"

	sed 	\
		-e 's|@prefix@|${pcfiledir}/../..|' \
		-e 's|@exec_prefix@|${prefix}|' \
		-e "s|@libdir@|\$\{exec_prefix\}/$(get_libdir)|" \
		-e "s|@libs@|-r:\$\{libdir\}/mono/Nini/Nini.dll|" \
		-e "s|@VERSION@|${PV}|" \
		"${FILESDIR}"/nini.pc.in > "${S}"/nini.pc
}

src_install() {
	egacinstall Nini.dll Nini
	pkgconfigdir=/usr/$(get_libdir)/pkgconfig
	insinto ${pkgconfigdir}
	newins "${S}"/nini.pc ${P}.pc
	dosym ${P}.pc ${pkgconfigdir}/${PN}-$(get_version_component_range 1-2).pc
	dosym ${P}.pc ${pkgconfigdir}/${PN}.pc

	dodoc "${S}"/../CHANGELOG.txt "${S}"/../README.txt
}
