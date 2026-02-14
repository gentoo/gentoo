# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{12..14} )

DOTNET_PKG_COMPAT="10.0"
NUGETS="
microsoft.netcore.platforms@1.1.0
microsoft.netframework.referenceassemblies.net461@1.0.0
microsoft.netframework.referenceassemblies.net461@1.0.3
microsoft.netframework.referenceassemblies.net472@1.0.3
microsoft.netframework.referenceassemblies@1.0.0
microsoft.netframework.referenceassemblies@1.0.3
netstandard.library@2.0.3
nxports@1.1.0
"

inherit check-reqs dotnet-pkg distutils-r1

DESCRIPTION="Generic pure Python loader for .NET runtimes"
HOMEPAGE="https://pythonnet.github.io/clr-loader/
	https://github.com/pythonnet/clr-loader/
	https://pypi.org/project/clr_loader/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/pythonnet/${PN}"
else
	inherit pypi

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

CHECKREQS_DISK_BUILD="500M"
DOTNET_PKG_PROJECTS=(
	example/example.csproj
	netfx_loader/ClrLoader.csproj
)

EPYTEST_DESELECT=(
	# Mono only.
	'tests/test_common.py::test_mono'
	'tests/test_common.py::test_mono_debug'
	'tests/test_common.py::test_mono_signal_chaining'
	'tests/test_common.py::test_mono_set_dir'

	# MS Windows only.
	'tests/test_common.py::test_netfx'
	'tests/test_common.py::test_netfx_chinese_path'
	'tests/test_common.py::test_netfx_separate_domain'

	# Fails.
	'tests/test_common.py::test_coreclr_properties'
)

distutils_enable_tests pytest

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_prepare() {
	# To be compatible with .NET >= 6.0.
	cat <<-EOF > Directory.Build.props || die
<Project>
<PropertyGroup>
<RollForward>Major</RollForward>
</PropertyGroup>
</Project>
EOF
	nuget_writeconfig "$(pwd)/"

	distutils-r1_src_prepare
}

src_configure() {
	dotnet-pkg_src_configure
	distutils-r1_src_configure
}
