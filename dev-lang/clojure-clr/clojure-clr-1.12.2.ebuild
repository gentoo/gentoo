# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
clojure.core.specs.alpha@0.4.74
clojure.data.generators@1.1.0
clojure.data.priority-map@1.2.0
clojure.spec.alpha@0.5.238
clojure.test.check@1.1.2
clojure.test.generative@1.1.2
clojure.tools.namespace@1.5.4
clojure.tools.reader@1.5.0
dynamiclanguageruntime@1.3.5
microsoft.applicationinsights@2.22.0
microsoft.applicationinsights@2.23.0
microsoft.codecoverage@17.13.0
microsoft.codecoverage@18.0.0
microsoft.extensions.dependencymodel@9.0.10
microsoft.extensions.dependencymodel@9.0.3
microsoft.net.test.sdk@17.13.0
microsoft.net.test.sdk@18.0.0
microsoft.testing.extensions.telemetry@1.5.3
microsoft.testing.extensions.telemetry@1.9.0
microsoft.testing.extensions.trxreport.abstractions@1.5.3
microsoft.testing.extensions.trxreport.abstractions@1.9.0
microsoft.testing.extensions.vstestbridge@1.5.3
microsoft.testing.extensions.vstestbridge@1.9.0
microsoft.testing.platform.msbuild@1.5.3
microsoft.testing.platform.msbuild@1.9.0
microsoft.testing.platform@1.5.3
microsoft.testing.platform@1.9.0
microsoft.testplatform.adapterutilities@17.13.0
microsoft.testplatform.objectmodel@17.12.0
microsoft.testplatform.objectmodel@17.13.0
microsoft.testplatform.objectmodel@18.0.0
microsoft.testplatform.testhost@17.13.0
microsoft.testplatform.testhost@18.0.0
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
nexpect@2.0.116
nexpect@2.0.124
nunit3testadapter@5.0.0
nunit3testadapter@5.2.0
nunit@4.3.2
nunit@4.4.0
system.codedom@8.0.0
system.runtime.serialization.formatters@9.0.10
system.runtime.serialization.formatters@9.0.3
system.runtime.serialization.formatters@9.0.8
"

inherit dotnet-pkg

DESCRIPTION="Port of the functional programming language Clojure to the CLR and .NET"
HOMEPAGE="https://github.com/clojure/clojure-clr/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/clojure/${PN}"
else
	SRC_URI="https://github.com/clojure/${PN}/archive/refs/tags/clojure-${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-clojure-${PV}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 BSD EPL-1.0 MIT"
SLOT="0"

DOCS=( README.md changes.md )
DOTNET_PKG_PROJECTS=( Clojure/Clojure.Main/Clojure.Main.csproj )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	sed -e "s|<TargetFrameworks.*|<TargetFrameworks>net${DOTNET_PKG_COMPAT}</TargetFrameworks>|g" \
		-e "s|net9.0|net${DOTNET_PKG_COMPAT}|g" \
		-e "s|mono |${DOTNET_PKG_EXECUTABLE} exec |g" \
		-i Clojure/*/*.csproj \
		|| die

	# Portage variable "FEATURES" confuses dotnet.
	sed -e "s|\$(Features);||g" -i Clojure/Directory.Build.props || die

	dotnet-pkg_src_prepare
}

src_configure() {
	dotnet-pkg-base_restore Clojure/Clojure.sln
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/Clojure.Main" "${PN}"

	einstalldocs
}
