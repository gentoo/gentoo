# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A malware identification and classification tool"
HOMEPAGE="http://virustotal.github.io/yara/"
SRC_URI="https://github.com/virustotal/yara/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+dex +dotnet +cuckoo +macho +magic profiling python"

DEPEND="
	dev-libs/openssl:0=
	cuckoo? ( dev-libs/jansson:= )
	magic? ( sys-apps/file:0= )
"
RDEPEND="${DEPEND}"
PDEPEND="python? ( =dev-python/yara-python-4* )"

S="${WORKDIR}/${PN}-${PV/_/-}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable profiling) \
		$(use_enable cuckoo) \
		$(use_enable magic) \
		$(use_enable dotnet) \
		$(use_enable macho) \
		$(use_enable dex)
}
