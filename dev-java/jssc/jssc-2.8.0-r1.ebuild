# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple toolchain-funcs

MY_PN="java-simple-serial-connector"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Java Simple Serial Connector"
HOMEPAGE="https://github.com/scream3r/java-simple-serial-connector"
SRC_URI="https://github.com/scream3r/${MY_PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	source? ( app-arch/zip )
	>=virtual/jdk-1.6"

PATCHES=(
	"${FILESDIR}/${P}-library-load.patch"
)

S="${WORKDIR}/${MY_P}"

java_prepare() {
	epatch "${PATCHES[@]}"
}

src_compile() {
	java-pkg-simple_src_compile
	$(tc-getCXX) \
		${CPP_FLAGS} ${CXX_FLAGS} \
		-c -o ${PN}.o \
		-fPIC -Wall \
		-I$(java-config-2 -o)/include \
		-I$(java-config-2 -o)/include/linux \
		"${S}/src/cpp/_nix_based/${PN}.cpp" || die

	$(tc-getCXX) \
		-Wl,-soname,libjssc.so \
		-shared -o "libjssc.so.${PV}" \
		-Wall "${PN}.o" || die
}

src_install() {
	java-pkg-simple_src_install
	dolib libjssc*
	dosym "libjssc.so.${PV}" /usr/$(get_libdir)/libjssc.so
}
