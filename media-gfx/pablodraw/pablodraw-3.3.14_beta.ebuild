# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="9.0"
NUGETS="
atksharp@3.24.24.95
cairosharp@3.24.24.95
eto.forms@2.9.0
eto.platform.gtk@2.9.0
gdksharp@3.24.24.95
giosharp@3.24.24.95
glibsharp@3.24.24.95
gtksharp@3.24.24.95
lidgren.network@1.0.2
microsoft.netcore.platforms@1.1.0
mono.nat@3.0.4
netstandard.library@2.0.3
newtonsoft.json@13.0.3
pangosharp@3.24.24.95
sharpcompress@0.32.2
system.buffers@4.5.1
system.componentmodel.annotations@5.0.0
system.memory@4.5.4
system.memory@4.5.5
system.numerics.vectors@4.4.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.text.encoding.codepages@6.0.0
system.text.encoding.codepages@9.0.0
"

inherit desktop dotnet-pkg xdg

DESCRIPTION="Ansi/Ascii text and RIPscrip vector graphic art editor/viewer"
HOMEPAGE="https://picoe.ca/products/pablodraw/
	https://github.com/cwensley/pablodraw/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/cwensley/${PN}"
else
	SRC_URI="https://github.com/cwensley/${PN}/archive/${PV/_/-}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${P/_/-}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

RDEPEND="
	 x11-libs/gtk+:3[introspection]
"
BDEPEND="
	${RDEPEND}
"

DOTNET_PKG_PROJECTS=( Source/PabloDraw/PabloDraw.csproj )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_install() {
	dotnet-pkg_src_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/PabloDraw" "${PN}"

	doicon Assets/PabloDraw.png
	make_desktop_entry "${PN}" PabloDraw PabloDraw "Graphics;RasterGraphics;"
}
