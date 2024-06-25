# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
atksharp@3.24.24.38
benchmarkdotnet.annotations@0.13.2
benchmarkdotnet@0.13.2
cairosharp@3.24.24.38
commandlineparser@2.4.3
gdksharp@3.24.24.38
giosharp@3.24.24.38
glibsharp@3.24.24.38
gtksharp@3.24.24.38
iced@1.17.0
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.codeanalysis.analyzers@2.6.2-beta2
microsoft.codeanalysis.common@3.0.0
microsoft.codeanalysis.csharp@3.0.0
microsoft.codecoverage@17.4.1
microsoft.diagnostics.netcore.client@0.2.251802
microsoft.diagnostics.runtime@2.2.332302
microsoft.diagnostics.tracing.traceevent@3.0.2
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.configuration.abstractions@2.1.1
microsoft.extensions.configuration.binder@2.1.1
microsoft.extensions.configuration@2.1.1
microsoft.extensions.dependencyinjection.abstractions@2.1.1
microsoft.extensions.logging.abstractions@2.1.1
microsoft.extensions.logging@2.1.1
microsoft.extensions.options@2.1.1
microsoft.extensions.primitives@2.1.1
microsoft.net.test.sdk@17.4.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.testplatform.objectmodel@17.4.1
microsoft.testplatform.testhost@17.4.1
netstandard.library@2.0.0
newtonsoft.json@13.0.1
ngettext@0.6.7
nuget.frameworks@5.11.0
nunit3testadapter@4.3.1
nunit@3.13.3
pangosharp@3.24.24.38
paragonclipper@6.4.2
perfolizer@0.2.1
sharpziplib@1.4.1
system.codedom@6.0.0
system.collections.immutable@1.5.0
system.collections.immutable@5.0.0
system.management@6.0.0
system.memory@4.5.1
system.memory@4.5.3
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.7.0
system.reflection.metadata@1.6.0
system.runtime.compilerservices.unsafe@4.5.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@5.0.0
system.security.principal.windows@4.7.0
system.text.encoding.codepages@4.5.0
system.threading.tasks.extensions@4.5.4
tmds.dbus@0.11.0
"

inherit autotools dotnet-pkg xdg

DESCRIPTION="Pinta is a free, open source program for drawing and image editing"
HOMEPAGE="https://www.pinta-project.com/
	https://github.com/PintaProject/Pinta/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/PintaProject/${PN^}.git"
else
	SRC_URI="https://github.com/PintaProject/${PN^}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

RDEPEND="
	 x11-libs/gtk+:3[introspection]
"
BDEPEND="
	${RDEPEND}
	dev-util/intltool
"

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	dotnet-pkg_src_prepare

	eautoreconf
}

src_configure() {
	econf

	dotnet-pkg_src_configure
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${ED}" install

	local -r pinta_home="/usr/$(get_libdir)/${PN}"

	mv "${ED}/usr/bin/pinta" "${ED}/${pinta_home}" || die
	sed -e 's|dotnet|${DOTNET_ROOT}/dotnet|g' \
		-i "${ED}/${pinta_home}/pinta" \
		|| die
	dotnet-pkg-base_dolauncher "${pinta_home}/${PN}" "${PN}"

	rm "${ED}/usr/share/man/man1/${PN}.1.gz" || die
	doman "./xdg/${PN}.1"
}
