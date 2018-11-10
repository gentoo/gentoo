# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools vcs-snapshot

MY_P="${PN^g}2-${PV}"
PV_COMMIT="6fca535f7bb950f81db066bd1afdca9d55e9b460"

DESCRIPTION="GTK2 binding for Gauche"
HOMEPAGE="http://practical-scheme.net/gauche/"
SRC_URI="https://github.com/shirok/${PN^g}2/archive/${PV_COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="examples glgd nls opengl"
RESTRICT="test"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="x11-libs/gtk+:2
	dev-scheme/gauche
	opengl? (
		x11-libs/gtkglext
		dev-scheme/gauche-gl
	)"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoconf
}

src_configure() {
	local myconf=()
	if use opengl; then
		if use glgd; then
			if use nls; then
				myconf+=( --enable-glgd-pango )
			else
				myconf+=( --enable-glgd )
			fi
		else
			myconf+=( --enable-gtkgl )
		fi
	fi

	econf "${myconf[@]}"
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
		if use opengl; then
			# install gtkglext
			dodoc -r examples/gtkglext
			if use glgd; then
				# install glgd
				dodoc -r examples/glgd
			fi
		fi
	fi
}
