# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/replicatorg/replicatorg-37-r2.ebuild,v 1.2 2014/01/08 06:44:31 vapier Exp $

EAPI="3"

inherit eutils versionator user

MY_P="${PN}-00${PV}"

DESCRIPTION="ReplicatorG is a simple, open source 3D printing program"
HOMEPAGE="http://replicat.org/start"
SRC_URI="http://replicatorg.googlecode.com/files/${MY_P}-linux.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEPEND="dev-java/oracle-jre-bin"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup replicator
}

pkg_postinst() {
	elog "Replicatorg requires Sun/Oracle JRE and will not work with OpenJDK."
	elog
	elog "Ensure that your user account has permissions to access serial port,"
	elog "if you plan to connect directly to a 3d printer rather than using"
	elog "a flash card. Printing directly from replicatorg is preferred."
	elog
	elog "The replicator printer will likely show up in /dev as ttyACM0."
	elog "You may want to autoload the cdc_acm kernel module."
	elog
	elog "Note that replicatorg includes its own version of skeinforge."
	elog "There doesn't seem to be a simple way to depend on an external"
	elog "version."
	elog
	elog "Replicatorg users should add themselves to the replicator group"
	elog "to avoid upstream warnings about not being able to modify shared"
	elog "skeinforge scripts."
	elog
	chmod -R g+w "${ROOT}"/opt/replicatorg
	chown -R root:replicator "${ROOT}"/opt/replicatorg
	chmod 0755 /opt/replicatorg
}

src_install() {
	dodir \
		/opt/replicatorg \
		/usr/share/replicatorg

	keepdir \
		/opt/replicatorg \
		/usr/share/replicatorg

	dobin "${FILESDIR}"/replicatorg

	/bin/cp -R --preserve=mode \
		docs \
		examples \
		lib \
		lib-i686 \
		lib-x86_64 \
		machines \
		scripts \
		replicatorg \
		skein_engines \
		tools \
		"${D}"/opt/replicatorg/

	insinto /usr/share/replicatorg
	doins -r \
   		contributors.txt \
		license.txt \
		readme.txt \
		todo.txt

}
