# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_P="${PN^g}2-${PV}"

DESCRIPTION="GTK2 binding for Gauche"
HOMEPAGE="https://practical-scheme.net/gauche/"
SRC_URI="https://github.com/shirok/${PN^g}2/releases/download/release-${PV}/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="examples"
RESTRICT="test"

RDEPEND="dev-scheme/gauche:=
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
S="${WORKDIR}/${MY_P}"

src_compile() {
	emake stubs
	emake
}

src_install() {
	default

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc examples/*.scm
		# install gtk-tutorial
		docinto examples/gtk-tutorial
		dodoc examples/gtk-tutorial/*
	fi
}
