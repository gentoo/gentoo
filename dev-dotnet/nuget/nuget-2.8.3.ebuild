# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit dotnet eutils

DESCRIPTION="Nuget - .NET Package Manager"
HOMEPAGE="http://nuget.codeplex.com"
SRC_URI="https://github.com/mrward/nuget/archive/Release-${PV}-MonoDevelop.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/nuget-Release-${PV}-MonoDevelop

LICENSE="Apache-2.0"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE=""

# Mask 3.2.0 because of mcs compiler bug : http://stackoverflow.com/a/17926731/238232
# it fixed in 3.2.3
DEPEND=">=dev-lang/mono-3.2.3
	<=dev-dotnet/xdt-for-monodevelop-2.8.2"
RDEPEND="${DEPEND}"

# note about blocking nuget:
# there are at least two versions of it - on from mono, one from mrward
# see https://bugzilla.xamarin.com/show_bug.cgi?id=27693
# i think version from mrward is enough for now, 
# that is why there is no slotted install or two different names/locations

pkg_setup() {
	dotnet_pkg_setup
	mozroots --import --sync --machine
}

src_prepare() {
	sed -i -e 's@RunTests@ @g' "${S}/Build/Build.proj" || die
	cp "${FILESDIR}/rsa-4096.snk" "${S}/src/Core/" || die
	epatch "${FILESDIR}/add-keyfile-option-to-csproj.patch"
	sed -i -E -e "s#(\[assembly: InternalsVisibleTo(.*)\])#/* \1 */#g" "src/Core/Properties/AssemblyInfo.cs" || die
	epatch "${FILESDIR}/strongnames-for-ebuild-2.8.1.patch"
}

src_configure() {
	export EnableNuGetPackageRestore="true"
}

src_compile() {
#	xbuild Build/Build.proj /p:Configuration=Release /p:TreatWarningsAsErrors=false /tv:4.0 /p:TargetFrameworkVersion="v${FRAMEWORK}" /p:Configuration="Mono Release" /t:GoMono || die
	source ./build.sh || die
}

src_install() {
	elog "Installing NuGet.Core.dll into GAC"
	egacinstall "src/Core/obj/Mono Release/NuGet.Core.dll"
	elog "Installing NuGet console application"
	insinto /usr/lib/mono/NuGet/"${FRAMEWORK}"/
	doins src/CommandLine/obj/Mono\ Release/NuGet.exe
	make_wrapper nuget "mono /usr/lib/mono/NuGet/${FRAMEWORK}/NuGet.exe"
}
