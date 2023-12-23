# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

DOTNET_PKG_COMPAT=8.0
NUGETS="
benchmarkdotnet.annotations@0.13.1
benchmarkdotnet@0.13.1
commandlineparser@2.4.3
iced@1.8.0
lost.compat.nullabilityattributes@0.0.4
microsoft.build.tasks.git@1.1.1
microsoft.codeanalysis.analyzers@2.6.1
microsoft.codeanalysis.common@2.10.0
microsoft.codeanalysis.csharp@2.10.0
microsoft.codecoverage@16.11.0
microsoft.codecoverage@17.0.0
microsoft.codecoverage@17.8.0
microsoft.csharp@4.7.0
microsoft.diagnostics.netcore.client@0.2.61701
microsoft.diagnostics.runtime@1.1.126102
microsoft.diagnostics.tracing.traceevent@2.0.61
microsoft.dotnet.internalabstractions@1.0.0
microsoft.dotnet.platformabstractions@2.1.0
microsoft.net.compilers.toolset@4.0.1
microsoft.net.test.sdk@16.11.0
microsoft.net.test.sdk@17.0.0
microsoft.net.test.sdk@17.8.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.netframework.referenceassemblies.net461@1.0.0
microsoft.netframework.referenceassemblies.net472@1.0.0
microsoft.netframework.referenceassemblies@1.0.0
microsoft.testplatform.objectmodel@16.11.0
microsoft.testplatform.objectmodel@17.8.0
microsoft.testplatform.testhost@16.11.0
microsoft.testplatform.testhost@17.8.0
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.3.0
microsoft.win32.registry@4.5.0
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.1
newtonsoft.json@9.0.1
noncopyableanalyzer@0.7.0
nuget.frameworks@5.0.0
nuget.frameworks@6.5.0
nunit3testadapter@3.16.1
nunit3testadapter@3.17.0
nunit3testadapter@4.5.0
nunit@3.12.0
nunit@3.14.0
perfolizer@0.2.1
runtime.any.system.collections@4.3.0
runtime.any.system.diagnostics.tools@4.3.0
runtime.any.system.diagnostics.tracing@4.3.0
runtime.any.system.globalization@4.3.0
runtime.any.system.io@4.3.0
runtime.any.system.reflection.extensions@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.resources.resourcemanager@4.3.0
runtime.any.system.runtime.handles@4.3.0
runtime.any.system.runtime.interopservices@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.text.encoding.extensions@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
system.appcontext@4.1.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.buffers@4.4.0
system.collections.concurrent@4.3.0
system.collections.immutable@1.5.0
system.collections.nongeneric@4.3.0
system.collections.specialized@4.3.0
system.collections@4.0.11
system.collections@4.3.0
system.componentmodel.eventbasedasync@4.3.0
system.componentmodel.primitives@4.3.0
system.componentmodel.typeconverter@4.3.0
system.componentmodel@4.3.0
system.console@4.3.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.fileversioninfo@4.3.0
system.diagnostics.process@4.3.0
system.diagnostics.stacktrace@4.3.0
system.diagnostics.tools@4.0.1
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.dynamic.runtime@4.0.11
system.dynamic.runtime@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq@4.1.0
system.linq@4.3.0
system.management@4.5.0
system.memory@4.5.3
system.numerics.vectors@4.4.0
system.objectmodel@4.0.12
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.0.1
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.0.1
system.reflection.emit@4.3.0
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.0.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.runtime@4.3.0
system.security.accesscontrol@4.5.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.5.0
system.text.encoding.codepages@4.3.0
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.2
system.threading.tasks.parallel@4.3.0
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.thread@4.3.0
system.threading.threadpool@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.valuetuple@4.5.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xdocument@4.3.0
system.xml.xmldocument@4.3.0
system.xml.xpath.xdocument@4.3.0
system.xml.xpath.xmldocument@4.3.0
system.xml.xpath@4.3.0
"

inherit check-reqs dotnet-pkg distutils-r1 readme.gentoo-r1

DESCRIPTION="Nearly seamless integration with the .NET Common Language Runtime"
HOMEPAGE="http://pythonnet.github.io/
	https://github.com/pythonnet/pythonnet/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/pythonnet/${PN}.git"
else
	inherit pypi

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/clr-loader[${PYTHON_USEDEP}]
	dev-python/pycparser[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

CHECKREQS_DISK_BUILD="1500M"
PATCHES=( "${FILESDIR}/${PN}-3.0.3-no-sourcelink.patch" )

EPYTEST_DESELECT=(
	'tests/test_engine.py::test_import_module'
	'tests/test_engine.py::test_run_string'
	'tests/test_method.py::test_getting_method_overloads_binding_does_not_leak_memory'
	'tests/test_method.py::test_params_array_overloaded_failing'
	'tests/test_module.py::test_assembly_load_recursion_bug'
	'tests/test_module.py::test_implicit_assembly_load'
)

DOCS=( AUTHORS.md CHANGELOG.md README.rst )
DOC_CONTENTS="Python.NET defaults to the mono runtime, not .NET SDK's coreclr.
You can workaround this either by exporting PYTHONNET_RUNTIME=coreclr or some
Python code. Please read the documentation on
https://pythonnet.github.io/pythonnet/python.html"

distutils_enable_tests pytest

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare

	# Because python scripts perform the build.
	cat <<EOF > NuGet.config || die
<?xml version="1.0" encoding="utf-8"?>
<configuration>
<packageSources>
<clear />
<add key="nuget" value="${NUGET_PACKAGES}" />
</packageSources>
</configuration>
EOF
}

src_configure() {
	dotnet-pkg_src_configure
	distutils-r1_src_configure
}

python_test() {
	epytest --runtime coreclr
}

src_install() {
	distutils-r1_src_install

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
