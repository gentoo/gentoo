# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN=PowerShell
DESCRIPTION="PowerShell Core is a cross-platform automation and configuration tool/framework"
HOMEPAGE="https://powershell.org/"
KEYWORDS="~amd64"
LICENSE="MIT"
SRC_URI="https://github.com/PowerShell/PowerShell/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
RESTRICT+=" network-sandbox"
DOTNET_MIN_VER=6
# TODO: Can we test if some flags were respected?
# Similar issue for Rust: https://bugs.gentoo.org/796887
QA_FLAGS_IGNORED=".*"
QA_PRESTRIPPED=".*"
RDEPEND="
	app-crypt/mit-krb5:=
	dev-util/lttng-ust:=
	dev-libs/openssl:=
	sys-libs/pam:=
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	|| ( app-shells/pwsh-bin app-shells/pwsh )
	>=virtual/dotnet-sdk-${DOTNET_MIN_VER}
"
S=${WORKDIR}/${MY_PN}-${PV}

fake-git-describe() {
	echo "v${PV}-0-ge22c2cf6f9653e10a2a37371d11ac4f18c3fd681"
}

dotnet_find() {
	local x
	for x in "${DOTNET_ROOT}" "${BROOT}"/usr/lib/dotnet-sdk-* "${BROOT}"/opt/dotnet-sdk-bin-*; do
		if [[ -x "${x}/dotnet" ]]; then
			[[ $(cd "${T}" && "${x}/dotnet" --version) =~ ([[:digit:]]*).([[:digit:]]*) ]] || continue
			if (( ${BASH_REMATCH[1]} >= DOTNET_MIN_VER )); then
				DOTNET_ROOT="${x}"
				DOTNET_SLOT=${BASH_REMATCH[1]}.${BASH_REMATCH[2]}
				break
			fi
		fi
	done

	if [[ ! -d "${DOTNET_ROOT}" ]]; then
		die "Can't find installed .NET SDK version ${DOTNET_MIN_VER} or later"
	fi
}

src_prepare() {
	local dotnet_version
	dotnet_version=$(cd "${T}" && dotnet --version) || die
	sed -e 's/\([^#]\)\(Install-Dotnet @DotnetArguments\)/\1#\2/' -i ./build.psm1 || die
	#sed -e 's/\([^#]\)\(Restore-PSPackage -Options\)/\1#\2/' -i ./build.psm1 || die
	sed -e 's|"version": .*|"version": "'${dotnet_version}'"|' -i ./global.json || die
	sed -e "s|<Exec Command='git describe[^']*'|<Exec Command='echo $(fake-git-describe)'|" -i PowerShell.Common.props || die
	default
}

src_compile() {
	dotnet_find
	[[ ${PATH} == ${DOTNET_ROOT}:* ]] || PATH=${DOTNET_ROOT}:${PATH}
	addpredict "${DOTNET_ROOT}/metadata"
	einfo Start-PSBootstrap
	pwsh -NonInteractive -c 'Import-Module ./build.psm1 -ArgumentList $true
Start-PSBootstrap
' || die "Start-PSBootstrap failed"

	einfo Start-PSBuild
	pwsh -NonInteractive -c "Import-Module ./build.psm1 -ArgumentList \$true
Start-PSBuild -ReleaseTag v${PV}
" || die "Start-PSBuild  failed"
}

src_test() {
	local failures=0 pwsh_exe=./src/powershell-unix/bin/Debug/net${DOTNET_SLOT}/linux-x64/pwsh

	ebegin "--version"
	[[ $("${pwsh_exe}" --version) == "${MY_PN} ${PV}" ]]
	eend "$?" "fail" || (( failures += 1 ))

	ebegin "hello world"
	[[ $("${pwsh_exe}" -NonInteractive -c "Write-Host 'hello world'") == "hello world" ]]
	eend "$?" "fail" || (( failures += 1 ))

	if (( failures > 0 )); then
		die "${failures} tests failed"
	fi
}

src_install() {
	local dest=usr/$(get_libdir)/pwsh symlink
	dodir "${dest%/*}"

	mv "${S}/src/powershell-unix/bin/Debug/net${DOTNET_SLOT}/linux-x64" "${ED}/${dest}" || die
	fperms 0755 "/${dest}/pwsh"

	dosym "../../${dest}/pwsh" "/usr/bin/pwsh"
}
