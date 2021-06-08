# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 xdg

MY_PN="NetLogo"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Programming language and IDE for agent-based modelling"
HOMEPAGE="https://ccl.northwestern.edu/netlogo/"
SRC_URI="
	https://netlogoweb.org/assets/images/desktopicon.png -> ${PN//-bin}.png
	amd64? ( https://ccl.northwestern.edu/netlogo/${PV}/${MY_P}-64.tgz )
	x86? ( https://ccl.northwestern.edu/netlogo/${PV}/${MY_P}-32.tgz )
"
S="${WORKDIR}/${MY_PN} ${PV}"

LICENSE="netlogo GPL-2 LGPL-2.1 LGPL-3 BSD Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.8:*
	media-libs/mesa
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXxf86vm
"

DOCS=(
	"readme.md"
	"NetLogo User Manual.pdf"
	"Mathematica Link/NetLogo-Mathematica Tutorial.pdf"
	"app/behaviorsearch/README.TXT"
)
HTML_DOCS=(
	"app/docs"
	"app/behaviorsearch/documentation"
)

QA_PREBUILT="opt/netlogo/app/natives/linux-*/*.so"

src_install() {
	einstalldocs

	# Remove the bundled libs if we are not installing on this arch
	# This avoids: "QA Notice: Unresolved SONAME dependencies:"
	if ! use amd64; then
		rm -r app/natives/linux-amd64 || die
	fi
	if ! use x86; then
		rm -r app/natives/linux-i586 || die
	fi

	# Override the config files so they don't use the bundled java path
	sed -i -e 's/app.runtime=.*/app.runtime=$JAVA_HOME/g' app/*.cfg || die

	local basedir="/opt/${PN//-bin}"
	insinto "${basedir}"
	doins -r app/
	# The whitespace causes issues when we try to java-pkg_regjar, because
	# classpath can't contain paths with whitespaces
	mv "Mathematica Link/" "MathematicaLink/" || die
	doins -r "MathematicaLink/"

	doicon -s 256x256 "${DISTDIR}/${PN//-bin}.png"
	doicon -s scalable app/behaviorsearch/resources/icon_behaviorsearch.svg
	doicon -s 256x256 app/behaviorsearch/resources/icon_behaviorsearch.png

	# Register all these jars so they are available in the classpath
	for jar in "${ED}/${basedir}/app/"*.jar ; do
		java-pkg_regjar "${jar}"
	done
	java-pkg_regjar "${ED}/${basedir}/MathematicaLink/mathematica-link.jar"

	use amd64 && java-pkg_dolauncher netlogo3d \
		--main org.nlogo.app.App \
		--pwd "${EPREFIX}/${basedir}" \
		--java_args "-Dnetlogo.extensions.dir=${EPREFIX}/${basedir}/app/extensions -Dorg.nlogo.is3d=true -Djava.library.path=${EPREFIX}/${basedir}/app/natives/linux-amd64/:\${env_var:PATH}"
	use x86 && java-pkg_dolauncher netlogo3d \
		--main org.nlogo.app.App \
		--pwd "${EPREFIX}/${basedir}" \
		--java_args "-Dnetlogo.extensions.dir=${EPREFIX}/${basedir}/app/extensions -Dorg.nlogo.is3d=true -Djava.library.path=${EPREFIX}/${basedir}/app/natives/linux-i586/:\${env_var:PATH}"
	java-pkg_dolauncher netlogo \
		--main org.nlogo.app.App \
		--pwd "${EPREFIX}/${basedir}" \
		--java_args "-Dnetlogo.extensions.dir=${EPREFIX}/${basedir}/app/extensions"
	java-pkg_dolauncher netlogo-headless \
		--main org.nlogo.headless.Main \
		--pwd "${EPREFIX}/${basedir}" \
		--java_args "-Dnetlogo.extensions.dir=${EPREFIX}/${basedir}/app/extensions"
	java-pkg_dolauncher hubnetclient \
		--main org.nlogo.hubnet.client.App \
		--pwd "${EPREFIX}/${basedir}" \
		--java_args "-Dnetlogo.extensions.dir=${EPREFIX}/${basedir}/app/extensions -Dorg.nlogo.is3d=true"
	java-pkg_dolauncher behaviorsearch \
		--main bsearch.app.BehaviorSearchGUI \
		--pwd "${EPREFIX}/${basedir}" \
		--java_args "-Dbsearch.startupfolder=${EPREFIX}/${basedir} -Dbsearch.appfolder=${EPREFIX}/${basedir}/app/behaviorsearch -server"
	java-pkg_dolauncher behaviorsearch-headless \
		--main bsearch.app.BehaviorSearch \
		--pwd "${EPREFIX}/${basedir}" \
		--java_args "-Dbsearch.startupfolder=${EPREFIX}/${basedir} -Dbsearch.appfolder=${EPREFIX}/${basedir}/app/behaviorsearch -server"

	make_desktop_entry netlogo "NetLogo" netlogo
	make_desktop_entry netlogo3d "NetLogo 3D" netlogo
	make_desktop_entry hubnetclient "NetLogo Hubnet Client" netlogo
	make_desktop_entry behaviorsearch "NetLogo Behavior Search" icon_behaviorsearch
}
