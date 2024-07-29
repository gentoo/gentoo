# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A malware identification and classification tool"
HOMEPAGE="https://virustotal.github.io/yara/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/VirusTotal/yara.git"
else
	SRC_URI="https://github.com/virustotal/yara/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${PV/_/-}"
	KEYWORDS="amd64 ~arm64 ~ppc64 x86"
fi

LICENSE="Apache-2.0"
SLOT="0/10"
IUSE="+dex +dotnet +cuckoo +macho +magic profiling python test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/openssl:=
	cuckoo? ( dev-libs/jansson:= )
	magic? ( sys-apps/file:= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
PDEPEND="python? ( =dev-python/yara-python-$(ver_cut 1)* )"

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
	find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
}
