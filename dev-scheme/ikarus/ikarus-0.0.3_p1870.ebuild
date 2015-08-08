# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils flag-o-matic autotools versionator

MY_PV=$(get_version_component_range 4-)
MY_PV=${MY_PV/p/}

MY_P=${PN}-scheme-r${MY_PV}

DESCRIPTION="A free optimizing incremental native-code compiler for R6RS Scheme"
HOMEPAGE="http://ikarus-scheme.org/"
SRC_URI="http://ikarus-scheme.org/ikarus.dev/${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="-* ~x86"
IUSE="cpu_flags_x86_sse2 doc"

RDEPEND=">=dev-libs/gmp-4.2.2"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e 's/-O3//' configure.ac || die
	epatch "${FILESDIR}/${P}-cpu_has_sse2.patch"
	epatch "${FILESDIR}/${P}-ikarus-enter.patch"

	eautoreconf
}

src_compile() {
	if use !cpu_flags_x86_sse2; then \
		eerror "You must have a processor who supports \
		SSE2 instructions" && die
	fi

	append-flags "-std=gnu99"

	emake || die "emake failed"
}

src_test() {
	cd benchmarks
	make benchall || die "Tests failed"
	if [ -e timelog ]
	then
		cat timelog || die "stdout test logs failed."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -Rf "${D}/usr/share"
	dodoc README ACKNOWLEDGMENTS || die "dodoc failed"
	if use doc; then
		dodoc doc/*.pdf || die "dodoc failed"
	fi
}
