# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TECH_MOSIS_VER="2002a"

DESCRIPTION="The VLSI design CAD tool"
HOMEPAGE="http://www.opencircuitdesign.com/magic/index.html"
SRC_URI="http://www.opencircuitdesign.com/${PN}/archive/${P}.tgz
	http://opencircuitdesign.com/~tim/programs/${PN}/archive/${TECH_MOSIS_VER}.tar.gz \
		-> ${PN}-tech-mosis-${TECH_MOSIS_VER}.tar.gz"

LICENSE="HPND GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="cairo debug opengl"

RDEPEND="sys-libs/ncurses:0=
	sys-libs/readline:0=
	dev-lang/tcl:0=
	dev-lang/tk:0=
	dev-tcltk/blt
	cairo? ( x11-libs/cairo[opengl?] )
	opengl? (
		virtual/glu
		virtual/opengl
	)"
DEPEND="${RDEPEND}"
BDEPEND="app-shells/tcsh"

PATCHES=(
	"${FILESDIR}"/${PN}-8.3.232-libdir.patch
	"${FILESDIR}"/${PN}-8.3.232-verbose-build.patch
)

DOCS=( README.md README.Tcl TODO )

src_prepare() {
	default

	pushd scripts &>/dev/null || die
	mv configure.in configure.ac || die
	popd &>/dev/null || die

	sed -i -e "s: -pg : :" tcltk/Makefile || die

	# required for >=autoconf-2.70 (bug #775422)
	local ac_aux_file
	for ac_aux_file in install-sh config.guess config.sub ; do
		ln -s scripts/${ac_aux_file} ${ac_aux_file} || die
	done
}

src_configure() {
	# Short-circuit top-level configure script to retain CFLAGS
	# fix tcl/tk detection #447868
	cd scripts || die
	econf \
		--with-tcl=yes \
		--with-tcllibs="/usr/$(get_libdir)" \
		--with-tklibs="/usr/$(get_libdir)" \
		--disable-modular \
		$(use_enable debug memdebug) \
		$(use_enable cairo cairo-offscreen) \
		$(use_with opengl)
}

src_install() {
	default

	# Move docs from libdir to docdir and add symlink.
	mv "${ED}/usr/$(get_libdir)/magic/doc"/* "${ED}/usr/share/doc/${PF}/" || die
	rmdir "${ED}/usr/$(get_libdir)/magic/doc" || die
	dosym -r "${EPREFIX}/usr/share/doc/${PF}" "/usr/$(get_libdir)/magic/doc"

	# Move tutorial from libdir to datadir and add symlink.
	dodir /usr/share/${PN}
	mv "${ED}/usr/$(get_libdir)/magic/tutorial" "${ED}/usr/share/${PN}/" || die
	dosym -r "${EPREFIX}/usr/share/${PN}/tutorial" "/usr/$(get_libdir)/magic/tutorial"

	# Install latest MOSIS tech files
	cp -pPR "${WORKDIR}"/${TECH_MOSIS_VER} "${ED}"/usr/$(get_libdir)/magic/sys/current || die
}
