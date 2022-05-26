# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Open Source Deep Packet Inspection Software Toolkit"
HOMEPAGE="https://www.ntop.org/"
SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/json-c:=
	net-libs/libpcap"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.4-fix-oob-in-kerberos-dissector.patch"
	"${FILESDIR}/${PN}-3.4-configure-fail-libcap.patch"
)

src_prepare() {
	eval $(grep '^NDPI_MAJOR=' autogen.sh)
	eval $(grep '^NDPI_MINOR=' autogen.sh)
	eval $(grep '^NDPI_PATCH=' autogen.sh)
	NDPI_VERSION_SHORT="${NDPI_MAJOR}.${NDPI_MINOR}.${NDPI_PATCH}"

	default

	sed \
		-e "s/@NDPI_MAJOR@/${NDPI_MAJOR}/g" \
		-e "s/@NDPI_MINOR@/${NDPI_MINOR}/g" \
		-e "s/@NDPI_PATCH@/${NDPI_PATCH}/g" \
		-e "s/@NDPI_VERSION_SHORT@/${NDPI_VERSION_SHORT}/g" \
		-e "s/@FUZZY@//g" \
		< "${S}/configure.seed" \
		> "${S}/configure.ac" || die

	sed -i \
		-e "s%^libdir\s*=\s*\${prefix}/lib\s*$%libdir     = \${prefix}/$(get_libdir)%" \
		src/lib/Makefile.in || die

	eautoreconf

	# Taken from autogen.sh (bug #704074):
	sed -i \
		-e "s/#define PACKAGE/#define NDPI_PACKAGE/g" \
		-e "s/#define VERSION/#define NDPI_VERSION/g" \
		configure || die
}

src_install() {
	default
	rm "${D}"/usr/$(get_libdir)/lib${PN,,}.a || die
}

src_test() {
	pushd tests || die
	./do.sh || die "Failed tests"
	./do-unit.sh || die "Failed tests"
	popd || die
}
