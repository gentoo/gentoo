# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Java server benchmark utility"
HOMEPAGE="http://www.volano.com/benchmarks.html"
SRC_URI="http://www.volano.com/pub/vmark2_5_0_9.class"
LICENSE="Volano"

# Below because of licensing.
RESTRICT="mirror"

SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""
DEPEND="virtual/jre
	>=sys-apps/sed-4
	sys-apps/net-tools"

RDEPEND="virtual/jre"

src_unpack() {
	einfo "No unpack required"
}

src_install() {
	dodir /opt/${PN}
	java -classpath "${DISTDIR}" vmark2_5_0_9 -o "${D}"/opt/${PN}
	chmod 755 "${D}"/opt/${PN}/*.sh
	sed -i -e "s#^host=.*#cd /opt/${PN}\nhost=`hostname`#" \
		-e 's:"$java":java:g' \
		-e 's:! -f: -z :' \
		-e 's:-Sn:-n:' \
		"${D}"/opt/${PN}/startup.sh

	sed -i -e "s#^./startup.sh#/opt/${PN}/startup.sh#g" "${D}"/opt/${PN}/*.sh

	# Set stack-size correctly for different arches
	if [ "${ARCH}" == "amd64" ] ; then
		sed -i -e 's:Xss96:Xss512:' "${D}"/opt/${PN}/startup.sh
	else
		sed -i -e 's:Xss96:Xss128:' "${D}"/opt/${PN}/startup.sh
	fi

	keepdir /opt/${PN}/logs
}

pkg_postinst() {

	ewarn "The vendor provided installation script is somewhat broken!"
	elog
	elog "startup.sh was patched to allow the use of the current JVM as"
	elog "selected by java-config. This means that regardless of the"
	elog "Java vendor you specify to ${PN}, it will STILL use the default"
	elog "JVM configured via java-config"
	elog
	elog "Just make sure that when you run ${PN}, the Java vendor you specify"
	elog "matches up with what java-config is configured for. Otherwise specific"
	elog "vendor specific options runtime may not work."
	elog
	elog "Remember to check the host property in startup.sh to the host that is"
	elog "running the server"

}
