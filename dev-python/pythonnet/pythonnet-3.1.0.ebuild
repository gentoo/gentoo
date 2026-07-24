# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_14 )

DOTNET_PKG_COMPAT="10.0"
NUGETS="
lost.compat.nullabilityattributes@0.0.4
microsoft.applicationinsights@2.23.0
microsoft.build.tasks.git@10.0.300
microsoft.codecoverage@18.6.0
microsoft.csharp@4.7.0
microsoft.extensions.dependencymodel@8.0.2
microsoft.net.compilers.toolset@5.3.0
microsoft.net.test.sdk@18.6.0
microsoft.netcore.platforms@1.1.0
microsoft.netframework.referenceassemblies.net461@1.0.0
microsoft.netframework.referenceassemblies.net461@1.0.3
microsoft.netframework.referenceassemblies.net472@1.0.0
microsoft.netframework.referenceassemblies.net472@1.0.3
microsoft.netframework.referenceassemblies@1.0.0
microsoft.netframework.referenceassemblies@1.0.3
microsoft.sourcelink.common@10.0.300
microsoft.sourcelink.github@10.0.300
microsoft.testing.extensions.telemetry@2.1.0
microsoft.testing.extensions.trxreport.abstractions@2.1.0
microsoft.testing.extensions.vstestbridge@2.1.0
microsoft.testing.platform.msbuild@2.1.0
microsoft.testing.platform@2.1.0
microsoft.testplatform.objectmodel@18.0.1
microsoft.testplatform.objectmodel@18.6.0
microsoft.testplatform.testhost@18.6.0
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.3
nunit3testadapter@6.2.0
nunit@3.14.0
nunit@4.6.1
system.buffers@4.5.1
system.buffers@4.6.1
system.collections.immutable@8.0.0
system.diagnostics.diagnosticsource@5.0.0
system.diagnostics.diagnosticsource@6.0.0
system.io.hashing@10.0.8
system.memory@4.5.4
system.memory@4.5.5
system.memory@4.6.3
system.numerics.vectors@4.5.0
system.numerics.vectors@4.6.1
system.reflection.emit.ilgeneration@4.7.0
system.reflection.emit@4.7.0
system.reflection.metadata@8.0.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.compilerservices.unsafe@6.1.2
system.threading.tasks.extensions@4.5.4
system.valuetuple@4.4.0
"

inherit check-reqs dotnet-pkg distutils-r1 readme.gentoo-r1

DESCRIPTION="Nearly seamless integration with the .NET Common Language Runtime"
HOMEPAGE="https://pythonnet.github.io/
	https://github.com/pythonnet/pythonnet/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pythonnet/${PN}"
else
	SRC_URI="https://github.com/pythonnet/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
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
PATCHES=(
	"${FILESDIR}/pythonnet-3.1.0-no-pyproject-parser.patch"
)

DOCS=( AUTHORS.md CHANGELOG.md README.rst )
DOC_CONTENTS="Python.NET defaults to the mono runtime, not .NET SDK's coreclr.
You can workaround this either by exporting PYTHONNET_RUNTIME=coreclr or some
Python code. Please read the documentation on
https://pythonnet.github.io/pythonnet/python.html"

EPYTEST_PLUGINS=()
EPYTEST_DESELECT=(
	'tests/test_codec.py::test_sequence'
	'tests/test_engine.py::test_import_module'
	'tests/test_engine.py::test_run_string'
	'tests/test_method.py::test_getting_method_overloads_binding_does_not_leak_memory'
	'tests/test_method.py::test_params_array_overloaded_failing'
	'tests/test_module.py::test_assembly_load_recursion_bug'
	'tests/test_module.py::test_implicit_assembly_load'
)
distutils_enable_tests pytest

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_prepare() {
	nuget_writeconfig "$(pwd)/"
	distutils-r1_src_prepare
}

src_configure() {
	dotnet-pkg_src_configure
	distutils-r1_src_configure
}

src_install() {
	distutils-r1_src_install
	readme.gentoo_create_doc
}

python_test() {
	local -x PYTHONNET_RUNTIME="coreclr"
	epytest --runtime coreclr
}

pkg_postinst() {
	readme.gentoo_print_elog
}
