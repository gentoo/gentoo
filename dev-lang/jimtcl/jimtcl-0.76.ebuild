# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multiprocessing eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="http://repo.or.cz/r/jimtcl.git"
	inherit git-2
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/msteveb/jimtcl/zipball/${PV} -> ${P}.zip"
	KEYWORDS="amd64 arm ~arm64 ~m68k ~mips ~s390 ~sh x86"
fi

DESCRIPTION="Small footprint implementation of Tcl programming language"
HOMEPAGE="http://jim.tcl.tk/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="doc? ( app-text/asciidoc )
	app-arch/unzip"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-2_src_unpack
	else
		default
		cd "${WORKDIR}"/msteveb-jimtcl-*
		S=${PWD}
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.75-bootstrap.patch
}

src_configure() {
	multijob_init
	CCACHE=None multijob_child_init econf --with-jim-shared
	if use static-libs ; then
		# The build does not support doing both simultaneously.
		mkdir static-libs
		cd static-libs
		CCACHE=None ECONF_SOURCE=${S} multijob_child_init econf
	fi
	multijob_finish
}

src_compile() {
	# Must build static-libs first.
	use static-libs && emake -C static-libs libjim.a
	emake all
	use doc && emake docs
}

src_install() {
	dobin jimsh
	use static-libs && dolib.a static-libs/libjim.a
	ln -sf libjim.so.* libjim.so
	dolib.so libjim.so*
	insinto /usr/include
	doins jim.h jimautoconf.h jim-subcmd.h jim-signal.h \
		jim-win32compat.h jim-eventloop.h jim-config.h
	dodoc AUTHORS README TODO
	use doc && dohtml Tcl.html
}
