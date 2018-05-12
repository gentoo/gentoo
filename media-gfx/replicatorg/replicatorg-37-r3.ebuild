# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator user

MY_P="${PN}-00${PV}"

DESCRIPTION="ReplicatorG is a simple, open source 3D printing program"
HOMEPAGE="http://replicat.org/start https://github.com/makerbot/ReplicatorG"
SRC_URI="https://replicatorg.googlecode.com/files/${MY_P}-linux.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="dev-java/oracle-jre-bin:*"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gsettings-desktop-schemas
"
DEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"

QA_WX_LOAD="
	/opt/replicatorg/skein_engines/slic3r_engines/linux/lib/vrt/f319e78215d06c9bbdc612ed9aef7e56/SSLeay.so
	/opt/replicatorg/skein_engines/slic3r_engines/linux/lib/vrt/80ccae99bc6b1afe192d6aa7724673cf/SSLeay.so"
QA_TEXTRELS="
	/opt/replicatorg/skein_engines/slic3r_engines/linux/lib/vrt/f319e78215d06c9bbdc612ed9aef7e56/SSLeay.so
	/opt/replicatorg/skein_engines/slic3r_engines/linux/lib/vrt/80ccae99bc6b1afe192d6aa7724673cf/SSLeay.so
	/opt/replicatorg/lib-i686/libj3dcore-ogl.so
	/opt/replicatorg/lib-i686/libj3dcore-ogl-cg.so"

pkg_setup() {
	enewgroup replicator
}

src_install() {
	dodir \
		/opt/replicatorg \
		/usr/share/replicatorg

	keepdir \
		/opt/replicatorg \
		/usr/share/replicatorg

	dobin "${FILESDIR}"/replicatorg

	insinto /opt/replicatorg/
	doins -r \
		docs \
		examples \
		lib \
		lib-i686 \
		lib-x86_64 \
		machines \
		scripts \
		replicatorg \
		skein_engines \
		tools

	insinto /usr/share/replicatorg
	doins -r \
		contributors.txt \
		license.txt \
		readme.txt \
		todo.txt
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

	chmod -R g+w "${EROOT%/}"/opt/replicatorg
	chown -R root:replicator "${EROOT%/}"/opt/replicatorg
	chmod 0755 /opt/replicatorg
}
