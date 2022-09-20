# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

MY_PV="${PV}"

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/"
LICENSE="MIT"

SRC_URI="
amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-x64.tar.gz )
arm? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-arm.tar.gz )
arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-arm64.tar.gz )
"

SLOT="3.1"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+dotnet-symlink"
REQUIRED_USE="elibc_glibc"
QA_PREBUILT="*"
RESTRICT+=" splitdebug"
RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-util/lttng-ust:0
	sys-libs/zlib:0/1
	dotnet-symlink? ( !dev-dotnet/dotnet-sdk[dotnet-symlink(+)] )
"

S=${WORKDIR}

src_install() {
	local dest="opt/${PN}-${SLOT}"
	dodir "${dest%/*}"

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

pkg_postinst() {
	# For bug #833281 Also, MS docs:
	# https://docs.microsoft.com/en-us/dotnet/core/runtime-config/globalization
	optfeature "globalization support" dev-libs/icu
}
