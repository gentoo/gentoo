# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV}"

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/"
LICENSE="MIT"

SRC_URI="
amd64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-x64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-musl-x64.tar.gz )
)
arm? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-arm.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-musl-arm.tar.gz )
)
arm64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-arm64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-musl-arm64.tar.gz )
)
"

SLOT="7.0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+dotnet-symlink"
QA_PREBUILT="*"
RESTRICT+=" splitdebug"
RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-libs/icu
	dev-util/lttng-ust:0/2.12
	sys-libs/zlib:0/1
	dotnet-symlink? (
		!dev-dotnet/dotnet-sdk[dotnet-symlink(+)]
		!dev-dotnet/dotnet-sdk-bin:3.1[dotnet-symlink(+)]
		!dev-dotnet/dotnet-sdk-bin:5.0[dotnet-symlink(+)]
		!dev-dotnet/dotnet-sdk-bin:6.0[dotnet-symlink(+)]
	)
"

S=${WORKDIR}

src_install() {
	local dest="opt/${PN}-${SLOT}"
	dodir "${dest%/*}"

	# Create a magic workloads file, bug #841896
	local featureband="$(ver_cut 3 | sed "s/[0-9]/0/2g")"
	local workloads="metadata/workloads/${SLOT}.${featureband}"
	{ mkdir -p "${S}/${workloads}" && touch "${S}/${workloads}/userlocal"; } || die

	{ mv "${S}" "${ED}/${dest}" && mkdir "${S}" && fperms 0755 "/${dest}"; } || die
	dosym "../../${dest}/dotnet" "/usr/bin/dotnet-bin-${SLOT}"

	if use dotnet-symlink; then
		dosym "../../${dest}/dotnet" "/usr/bin/dotnet"
		dosym "../../${dest}/dotnet" "/usr/bin/dotnet-${SLOT}"

		# set an env-variable for 3rd party tools
		echo "DOTNET_ROOT=/${dest}" > "${T}/90${PN}-${SLOT}" || die
		doenvd "${T}/90${PN}-${SLOT}"
	fi
}
