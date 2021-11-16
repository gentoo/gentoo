# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools vcs-snapshot

MY_P="${PN^g}2-${PV}"
PV_COMMIT="0220722c44ef85f2e1b9b14745702c1b923258e8"

DESCRIPTION="GTK2 binding for Gauche"
HOMEPAGE="https://practical-scheme.net/gauche/"
SRC_URI="https://github.com/shirok/${PN^g}2/archive/${PV_COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="examples"
RESTRICT="test"

RDEPEND="x11-libs/gtk+:2
	dev-scheme/gauche"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoconf
}

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
