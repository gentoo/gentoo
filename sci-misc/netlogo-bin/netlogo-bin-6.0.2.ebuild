# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

MY_PN="NetLogo"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Cross-platform multi-agent programmable modeling environment"
HOMEPAGE="http://ccl.northwestern.edu/netlogo/"
SRC_URI="
	https://dev.gentoo.org/~jlec/distfiles/${PN/-bin}.gif.tar
	amd64? ( http://ccl.northwestern.edu/netlogo/${PV}/${MY_P}-64.tgz )
	x86? ( http://ccl.northwestern.edu/netlogo/${PV}/${MY_P}-32.tgz )
"
LICENSE="netlogo GPL-2 LGPL-2.1 LGPL-3 BSD Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}/${MY_PN} ${PV}"

DOCS=( "NetLogo User Manual.pdf" app/docs/shapes.nlogo readme.md )
HTML_DOCS=( app/docs app/behaviorsearch/documentation )

QA_PREBUILT="opt/netlogo/app/natives/linux-*/*.so"

src_prepare() {
	default
	cp "${FILESDIR}"/netlogo-${PV}.sh netlogo.sh
	cp "${FILESDIR}"/netlogo3d-${PV}.sh netlogo3d.sh
	cp "${FILESDIR}"/behaviorsearch-${PV}.sh behaviorsearch.sh
	cp "${FILESDIR}"/hubnetclient-${PV}.sh hubnetclient.sh
	if use x86; then
		sed -i -e 's/linux-amd64/linux-i586/g' netlogo3d.sh
	fi
}

src_install() {
	einstalldocs

	# Override the config files so they don't use the bundled java path
	sed -i -e 's/app.runtime=.*/app.runtime=$JAVA_HOME/g' app/*.cfg

	# Once docs are installed, remove them from the source so they don't get
	# installed below
	rm -rf app/docs app/behaviorsearch/documentation
	insinto /opt/netlogo
	doins -r app/
	doins -r "Mathematica Link"

	doicon "${WORKDIR}"/netlogo.gif

	exeinto /opt/netlogo/
	# We don't copy the NetLogo binaries since they are hardcoded to use embedded java
	doexe netlogo.sh
	doexe netlogo3d.sh
	doexe behaviorsearch.sh
	doexe hubnetclient.sh
	doexe netlogo-headless.sh
	doexe app/behaviorsearch/behaviorsearch_headless.sh

	insinto /opt/bin
	dosym ../netlogo/netlogo.sh /opt/bin/netlogo.sh
	dosym ../netlogo/netlogo3d.sh /opt/bin/netlogo3d.sh
	dosym ../netlogo/behaviorsearch.sh /opt/bin/behaviorsearch.sh
	dosym ../netlogo/hubnetclient.sh /opt/bin/hubnetclient.sh
	dosym ../netlogo/netlogo-headless.sh /opt/bin/netlogo-headless.sh
	dosym ../netlogo/behaviorsearch_headless.sh /opt/bin/behaviorsearch_headless.sh

	make_desktop_entry behaviorsearch.sh "NetLogo Behavior Search" /usr/share/pixmaps/netlogo.gif
	make_desktop_entry netlogo.sh "NetLogo" /usr/share/pixmaps/netlogo.gif
	make_desktop_entry netlogo3d.sh "NetLogo 3D" /usr/share/pixmaps/netlogo.gif
	make_desktop_entry hubnetclient.sh "NetLogo Hubnet Client" /usr/share/pixmaps/netlogo.gif
}
