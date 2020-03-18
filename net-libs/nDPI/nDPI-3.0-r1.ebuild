# Copyright 1999-2019 Gentoo Authors
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

src_prepare() {
	sed \
		-e "s/@NDPI_MAJOR@/$(ver_cut 1)/g" \
		-e "s/@NDPI_MINOR@/$(ver_cut 2)/g" \
		-e "s/@NDPI_PATCH@/$(ver_cut 3)/g" \
		-e "s/@NDPI_VERSION_SHORT@/${PV}/g" \
		< "${S}/configure.seed" \
		> "${S}/configure.ac" || die

	sed -i \
		-e "s%^libdir\s*=\s*\${prefix}/lib\s*$%libdir     = \${prefix}/$(get_libdir)%" \
		src/lib/Makefile.in || die

	default
	eautoreconf
}

src_install() {
	default
	if ! use static-libs; then
		rm "${D}"/usr/$(get_libdir)/lib${PN,,}.a || die
	fi
}
