# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

ROOT_PN="root"
PATCH_PV="5.32"

if [[ ${PV} == "9999" ]] ; then
	_SVN_DEP="dev-vcs/subversion"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="ftp://root.cern.ch/${ROOT_PN}/${ROOT_PN}_v${PV}.source.tar.gz"
	KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
fi

inherit eutils multilib toolchain-funcs virtualx

DESCRIPTION="API documentation for ROOT (An Object-Oriented Data Analysis Framework)"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""

S="${WORKDIR}/${ROOT_PN}"
VIRTUALX_REQUIRED="always"

DEPEND="
	~sci-physics/root-${PV}[X,doc,graphviz,htmldoc,opengl]
	virtual/pkgconfig
	${_SVN_DEP}"
RDEPEND=""

pkg_setup() {
	# sandboxed user can't access video hardware, so xorg-x11 implementation
	# should be used
	GL_IMPLEM=$(eselect opengl show)
	eselect opengl set xorg-x11
}

src_unpack() {
	# can't use subversion eclass functions,
	# we need to svn export the same root tree:
	# 1) svn revisions for root and root-docs must be the same;
	# 2) no need to abuse server twice.
	if [[ ${PV} == "9999" ]] ; then
		addpredict "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/svn-src/${ROOT_PN}/trunk/.svn"
		svn export "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/svn-src/${ROOT_PN}/trunk" \
			"${S}" || die "svn export failed"
	else
		default
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PATCH_PV}-makehtml.patch
}

src_configure() {
	# we need only to setup paths here, html docs doesn't depend on USE flags
	./configure \
		--prefix="${EPREFIX}"/usr \
		--etcdir="${EPREFIX}"/etc/root \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/${PN} \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--tutdir="${EPREFIX}"/usr/share/doc/${PF}/examples/tutorials \
		--testdir="${EPREFIX}"/usr/share/doc/${PF}/examples/tests \
		--with-cc=$(tc-getCC) \
		--with-cxx=$(tc-getCXX) \
		--with-f77=$(tc-getFC) \
		--with-ld=$(tc-getCXX) \
		--with-afs-shared=yes \
		--with-llvm-config="${EPREFIX}"/usr/bin/llvm-config \
		--with-sys-iconpath="${EPREFIX}"/usr/share/pixmaps
}

src_compile() {
	ROOTSYS="${S}" Xemake html
	# if root.exe crashes, return code will be 0 due to gdb attach,
	# so we need to check if last html file was generated;
	# this check is volatile and can't catch crash on the last file.
	[[ -f htmldoc/timespec.html ]] || die "looks like html doc generation crashed"
}

src_install() {
	dodir /usr/share/doc/${PF}
	# too large data to copy
	mv htmldoc/* "${ED}usr/share/doc/${PF}/"
}

pkg_postinst() {
	eselect opengl set ${GL_IMPLEM}
}
