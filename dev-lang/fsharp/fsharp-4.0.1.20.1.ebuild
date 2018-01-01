# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils mono-env

DESCRIPTION="The F# Compiler"
HOMEPAGE="https://github.com/fsharp/fsharp"
SRC_URI="https://github.com/fsharp/fsharp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

MAKEOPTS+=" -j1" #nowarn
DEPEND=">=dev-lang/mono-3"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

# try to sync certificates
# deprecated way: mozroots --import --sync --machine
pkg_setup() {
	#this is horrible, I know
	addwrite "/usr/share/.mono/keypairs"
	addwrite "/etc/ssl/certs/ca-certificates.crt"
	addwrite "/etc/mono/registry"
	cert-sync /etc/ssl/certs/ca-certificates.crt
}

src_install() {
	autotools-utils_src_install
}
