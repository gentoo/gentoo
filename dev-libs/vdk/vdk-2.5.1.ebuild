# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A Visual Development Kit for RAD"
SRC_URI="mirror://sourceforge/vdklib/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/vdklib/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ppc x86"
IUSE="doc debug"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	local myconf=""

	# gnome and sigc USE flags need to be added later
	# when upstream decides to re-support them - ChrisWhite

	use doc && \
		myconf="${myconf} --enable-doc-html=yes \
						  --enable-doc-latex=yes \
						  --enable-doc-man=yes" \
		|| myconf="${myconf} --enable-doc-html=no \
							 --enable-doc-latex=no \
							 --enable-doc-man=no"

	use debug && \
		myconf="${myconf} --enable-debug=yes" \
		|| myconf="${myconf} --enable-debug=no"

	econf \
		${myconf} \
		--enable-testvdk=no \
		|| die "econf failed"

		# die non user custom CFLAGS!
		sed -e "s/CFLAGS = .*/CFLAGS = ${CFLAGS}/" -i Makefile
		sed -e "s/CXXFLAGS = .*/CXXFLAGS = ${CXXFLAGS}/" -i Makefile
		sed -e "s/CFLAGS = .*/CFLAGS = ${CFLAGS}/" -i vdk/Makefile
		sed -e "s/CXXFLAGS = .*/CXXFLAGS = ${CXXFLAGS}/" -i vdk/Makefile
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README TODO
}
