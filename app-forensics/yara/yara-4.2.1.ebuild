# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A malware identification and classification tool"
HOMEPAGE="http://virustotal.github.io/yara/"
SRC_URI="https://github.com/virustotal/yara/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV/_/-}"

LICENSE="Apache-2.0"
SLOT="0/8"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~amd64 ~x86"
fi
IUSE="+dex +dotnet +cuckoo +macho +magic profiling python test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/openssl:=
	cuckoo? ( dev-libs/jansson:= )
	magic? ( sys-apps/file:= )
"
RDEPEND="${DEPEND}"
PDEPEND="python? ( =dev-python/yara-python-$(ver_cut 1)* )"

PATCHES=( "${FILESDIR}/${PN}-$(ver_cut 1-2)-test.patch" )

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
		$(use_enable dex) \
		$(use_enable test static)
}

src_test() {
	emake check
}

src_install() {
	default

	# TODO: Allow tests to work against dyn. lib rather than building
	# statically just for tests.
	find "${ED}" -name '*.a' -delete || die
}
