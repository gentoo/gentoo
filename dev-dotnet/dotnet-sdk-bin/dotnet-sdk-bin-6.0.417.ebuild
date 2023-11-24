# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/"
SRC_URI="
amd64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-x64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-x64.tar.gz )
)
arm? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-arm.tar.gz )
)
arm64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-arm64.tar.gz )
)
"
S="${WORKDIR}"

SDK_SLOT="$(ver_cut 1-2)"
RUNTIME_SLOT="${SDK_SLOT}.25"
SLOT="${SDK_SLOT}/${RUNTIME_SLOT}"

LICENSE="MIT"
KEYWORDS="~amd64 arm arm64"
RESTRICT="splitdebug"

RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-libs/icu
	dev-util/lttng-ust:0/2.12
	sys-libs/zlib:0/1
"
IDEPEND="app-eselect/eselect-dotnet"
PDEPEND="
	~dev-dotnet/dotnet-runtime-nugets-${RUNTIME_SLOT}
	~dev-dotnet/dotnet-runtime-nugets-3.1.32
"

QA_PREBUILT="*"

src_install() {
	local dest=opt/${PN}-${SDK_SLOT}
	dodir "${dest%/*}"

	# Create a magic workloads file, bug #841896
	local featureband="$(( $(ver_cut 3) / 100 * 100 ))"       # e.g. 404 -> 400
	local workloads="metadata/workloads/${SDK_SLOT}.${featureband}"

	mkdir -p "${S}/${workloads}" || die
	touch "${S}/${workloads}/userlocal" || die

	mv "${S}" "${ED}/${dest}" || die
	mkdir "${S}" || die

	fperms 0755 "/${dest}"
	dosym ../../${dest}/dotnet /usr/bin/dotnet-bin-${SDK_SLOT}
}

pkg_postinst() {
	eselect dotnet update ifunset
}

pkg_postrm() {
	eselect dotnet update ifunset
}
