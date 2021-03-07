# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Probabilistic Alignment Kit"
HOMEPAGE="http://wasabiapp.org/software/prank/"
SRC_URI="http://wasabiapp.org/download/${PN}/${PN}.source.${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-msa/src"
PATCHES=( "${FILESDIR}/${PN}-140603-fix-c++14.patch" )

src_prepare() {
	sed \
		-e "s/\$(LINK)/& \$(LDFLAGS)/" \
		-e "s:/usr/lib:${EPREFIX}/usr/$(get_libdir):g" \
		-i Makefile || die
	default
}

src_compile() {
	emake \
		LINK="$(tc-getCXX)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dobin ${PN}
}
