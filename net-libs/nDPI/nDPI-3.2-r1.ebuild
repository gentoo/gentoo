# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib

DESCRIPTION="Open Source Deep Packet Inspection Software Toolkit"
HOMEPAGE="https://www.ntop.org/"
SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	dev-libs/json-c:=
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.2-0000-Check-NULL-strings-in-ndpi_serialize_string_string.patch
	"${FILESDIR}"/${PN}-3.2-0001-Added-fix-for-serialization-loop.patch
	"${FILESDIR}"/${PN}-3.2-0002-Refresh-of-ndpi_netbios_name_interpret.patch
	"${FILESDIR}"/${PN}-3.2-0003-Fixed-invalid-allocation.patch
	"${FILESDIR}"/${PN}-3.2-0004-Fix-for-serialization-of-strings-where-the-first-element-is-a-zero-le.patch
)

src_prepare() {
	eval $(grep '^NDPI_MAJOR=' autogen.sh)
	eval $(grep '^NDPI_MINOR=' autogen.sh)
	eval $(grep '^NDPI_PATCH=' autogen.sh)
	NDPI_VERSION_SHORT="${NDPI_MAJOR}.${NDPI_MINOR}.${NDPI_PATCH}"

	sed \
		-e "s/@NDPI_MAJOR@/${NDPI_MAJOR}/g" \
		-e "s/@NDPI_MINOR@/${NDPI_MINOR}/g" \
		-e "s/@NDPI_PATCH@/${NDPI_PATCH}/g" \
		-e "s/@NDPI_VERSION_SHORT@/${NDPI_VERSION_SHORT}/g" \
		< "${S}/configure.seed" \
		> "${S}/configure.ac" || die

	sed -i \
		-e "s%^libdir\s*=\s*\${prefix}/lib\s*$%libdir     = \${prefix}/$(get_libdir)%" \
		src/lib/Makefile.in || die

	default
	eautoreconf

	# Taken from autogen.sh (bug #704074):
	sed -i \
		-e "s/#define PACKAGE/#define NDPI_PACKAGE/g" \
		-e "s/#define VERSION/#define NDPI_VERSION/g" \
		configure || die
}

src_install() {
	default
	if ! use static-libs; then
		rm "${D}"/usr/$(get_libdir)/lib${PN,,}.a || die
	fi
}
