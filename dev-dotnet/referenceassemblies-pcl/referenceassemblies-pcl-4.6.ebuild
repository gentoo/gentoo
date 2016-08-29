# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit rpm

HOMEPAGE="https://developer.xamarin.com/guides/cross-platform/application_fundamentals/pcl/"
DESCRIPTION=".NET Portable Class Library reference assemblies"
SRC_URI="http://download.mono-project.com/repo/centos/r/referenceassemblies-pcl/referenceassemblies-pcl-${PV}-0.noarch.rpm"
# https://www.microsoft.com/net/dotnet_library_license.htm
# https://www.microsoft.com/web/webpi/eula/net_library_eula_enu.htm
LICENSE="dotnet-eula"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/mono-4.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	cp -R "${S}/"* "${D}/" || die "Install failed!"
}
