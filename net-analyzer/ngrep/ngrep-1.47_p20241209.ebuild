# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A grep for network layers"
HOMEPAGE="https://github.com/jpr5/ngrep"
if [[ ${PV} == *_p* ]] ; then
	NGREP_COMMIT="b2e3ba3c5a593abf203e65a407c3a9de0f998d4a"
	SRC_URI="https://github.com/jpr5/ngrep/archive/${NGREP_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}"/${PN}-${NGREP_COMMIT}
else
	SRC_URI="https://github.com/jpr5/ngrep/archive/V${PV/./_}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P/./_}"
fi

LICENSE="ngrep"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 ~s390 ~sparc x86"
IUSE="ipv6"

DEPEND="
	dev-libs/libpcre
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
	acct-group/ngrep
	acct-user/ngrep
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.47-regex.patch
	"${FILESDIR}"/${PN}-1.47-clang16.patch
)

src_prepare() {
	default

	sed -i -e "s:configure.in:configure.ac:" regex*/{configure.in,Makefile.in} || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable ipv6)
		--disable-pcap-restart
		--enable-pcre
		--with-dropprivs-user=ngrep
		--with-pcap-includes="${EPREFIX}"/usr/include/pcap
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake STRIPFLAG="${CFLAGS}"
}
