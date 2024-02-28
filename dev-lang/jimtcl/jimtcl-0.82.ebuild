# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs edo

SRC_URI="https://github.com/msteveb/jimtcl/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~mips ~s390 ~x86"

DESCRIPTION="Small footprint implementation of Tcl programming language"
HOMEPAGE="http://jim.tcl.tk/"

LICENSE="LGPL-2"
SLOT="0/${PV}"
IUSE="doc static-libs"

DEPEND="
	dev-lang/tcl:0
"

src_prepare() {
	# Avoid tests that need networking
	rm tests/ssl.test || die
	default
}

src_configure() {
	# Use the provided bootstrap tclsh, avoiding the script picking a different one
	edo $(tc-getCC) -o jimsh0 autosetup/jimsh0.c

	export CCACHE=none
	econf --disable-docs --shared
	if use static-libs; then
		# The build does not support doing both simultaneously.
		mkdir static-libs || die
		cd static-libs || die
		ECONF_SOURCE="${S}" econf --disable-docs
	fi
}

src_compile() {
	# Must build static-libs first.
	use static-libs && emake -C static-libs V=1 libjim.a
	emake V=1 all
}

src_install() {
	default
	use static-libs && dolib.a static-libs/libjim.a
	use doc && dodoc Tcl_shipped.html
}
