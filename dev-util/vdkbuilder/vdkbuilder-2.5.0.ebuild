# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/vdkbuilder/vdkbuilder-2.5.0.ebuild,v 1.4 2015/01/15 11:26:00 armin76 Exp $

EAPI=5

inherit eutils autotools

MY_P=${PN}2-${PV}

DESCRIPTION="The Visual Development Kit used for VDK Builder"
HOMEPAGE="http://vdkbuilder.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=" ~amd64 ~ppc ~x86"
IUSE="nls debug"

RDEPEND=">=dev-libs/vdk-2.5.0"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

custom_cflags() {
	for files in *
	do
		if [ -e ${files}/Makefile ]
		then
			sed -e "s/CFLAGS = .*/CFLAGS = ${CFLAGS} -I../include/" -i ${files}/Makefile
			sed -e "s/CXXFLAGS = .*/CFLAGS = ${CXXFLAGS} -I../include/" -i ${files}/Makefile
		fi
	done
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.4.0-make-382.patch || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.in || die
	eautoreconf
}

src_configure() {
	eautoreconf

	local myconf=""

	use debug \
		&& myconf="${myconf} --enable-devel=yes" \
		|| myconf="${myconf} --enable-devel=no"

	econf \
		$(use_enable nls) \
		--disable-vdktest \
		${myconf} || die "econf failed"

	custom_cflags
}

src_compile() {
	emake -j1 || die
}

src_install () {
	einstall || die
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
