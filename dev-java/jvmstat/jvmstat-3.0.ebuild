# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit java-pkg-2 versionator

MY_PV=$(replace_version_separator 1 '_')
DESCRIPTION="Monitoring APIs and tools for monitoring the performance of the JVM"
HOMEPAGE="http://java.sun.com/performance/jvmstat/"
SRC_URI="jvmstat-${MY_PV}.zip"

LICENSE="sun-bcla-jvmstat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/jvmstat/"

INSTTO="/opt/${PN}"

pkg_nofetch() {

	einfo "Please go to following URL:"
	einfo " ${HOMEPAGE}"
	einfo "download file named ${SRC_URI} and place it into"
	einfo " your DISTDIR directory."

}

src_install() {

	dodir "${INSTTO}"
	cd "${S}"
	cp -r jars bin "${D}/${INSTTO}"

	dodoc README
	use doc && dodoc -r docs

	dodir /opt/bin
	cat > "${D}/opt/bin/visualgc" <<-EOF
	#!/bin/bash
	export JVMSTAT_JAVA_HOME=$(java-config -O)
	cd /opt/jvmstat/bin/
	./visualgc \${@}
	EOF
	fperms 755 /opt/bin/visualgc

}
