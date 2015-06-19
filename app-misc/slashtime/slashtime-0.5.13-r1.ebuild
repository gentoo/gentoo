# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/slashtime/slashtime-0.5.13-r1.ebuild,v 1.3 2014/02/24 01:07:30 phajdan.jr Exp $

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2

DESCRIPTION="View the time at locations around the world"
HOMEPAGE="http://research.operationaldynamics.com/projects/slashtime/"
SRC_URI="http://research.operationaldynamics.com/projects/${PN}/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEP="dev-java/java-gnome:4.1"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

src_configure() {
	# Handwritten in perl so not using econf
	./configure prefix=/usr jardir=/usr/share/${PN}/lib || die
}

src_compile() {
	emake
}

src_install() {
	# This is needed to generate the slashtime jar.
	emake -j1 DESTDIR="${D}" install

	java-pkg_register-dependency java-gnome-4.1 gtk.jar
	java-pkg_regjar /usr/share/${PN}/lib/${PN}.jar

	# Replace slashtime launcher with our own.
	rm "${D}"/usr/bin/slashtime || die
	java-pkg_dolauncher ${PN} --main slashtime.client.Master --pwd /usr

	dodoc AUTHORS HACKING PLACES README TODO

	use source && java-pkg_dosrc src/java/slashtime
}
