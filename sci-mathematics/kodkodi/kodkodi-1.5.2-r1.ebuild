# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple multilib

DESCRIPTION="A text front-end for the Kodkod Java library"
HOMEPAGE="http://www21.in.tum.de/~blanchet/#software"
SRC_URI="http://www21.in.tum.de/~blanchet/${P}.tgz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="isabelle examples"

COMMON_DEP="dev-java/antlr:3
	=sci-mathematics/kodkod-1.5*:="
RDEPEND="${COMMON_DEP}
	isabelle? (
		sci-mathematics/isabelle:=
	)
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.6
	app-arch/unzip"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="kodkod,antlr-3"

src_prepare() {
	default
	sed -e 's@exec "$ISABELLE_TOOL" java $KODKODI_JAVA_OPT@java@' \
		-i "${S}/bin/kodkodi" || die "Could not patch bin/kodkodi"
	rm -f jar/*.jar || die "Could not rm jar files"
}

src_compile() {
	JAVA_SRC_DIR="src"
	TARGETDIR="/usr/share/${P}"
	KODKOD_LIBDIR="/usr/"$(get_libdir)"/kodkod"

	java-pkg-simple_src_compile

	pushd "${S}/target/classes" > /dev/null || die
	jar -uf "${S}"/${PN}.jar $(find -name '*.class') || die
	popd > /dev/null
}

src_install() {
	java-pkg-simple_src_install
	dodoc README HISTORY manual/${PN}.pdf LICENSES/Kodkodi
	insinto ${TARGETDIR}
	if use examples; then
		doins -r examples
	fi

	if use isabelle; then
		ISABELLE_HOME="$(isabelle getenv ISABELLE_HOME | cut -d'=' -f 2)" \
			|| die "isabelle getenv ISABELLE_HOME failed"
		[[ -n "${ISABELLE_HOME}" ]] || die "ISABELLE_HOME empty"
		dodir "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		cat <<- EOF >> "${S}/settings"
			KODKODI="\$COMPONENT"
			KODKODI_VERSION="${PV}"
			KODKODI_PLATFORM=\$ISABELLE_PLATFORM
			KODKODI_CLASSPATH="$(java-config --classpath=antlr:3):${ROOT}usr/share/${PN}-${SLOT}/lib/kodkodi.jar:$(java-config --classpath=kodkod)"
			KODKODI_JAVA_LIBRARY_PATH="${KODKOD_LIBDIR}"
		EOF
		insinto "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		doins "${S}/settings"
		dodir "${ISABELLE_HOME}/contrib/${PN}-${PV}/bin"
		exeinto "${ISABELLE_HOME}/contrib/${PN}-${PV}/bin"
		doexe bin/kodkodi
	fi
}

pkg_postinst() {
	if use isabelle; then
		if [ -f "${ROOT}etc/isabelle/components" ]; then
			if egrep "contrib/${PN}-[0-9.]*" "${ROOT}etc/isabelle/components"; then
				sed -e "/contrib\/${PN}-[0-9.]*/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
			cat <<- EOF >> "${ROOT}etc/isabelle/components"
				contrib/${PN}-${PV}
			EOF
		fi
	fi
}

pkg_postrm() {
	if use isabelle; then
		if [ ! -f "${ROOT}usr/bin/kodkodi" ]; then
			if [ -f "${ROOT}etc/isabelle/components" ]; then
				# Note: this sed should only match the version of this ebuild
				# Which is what we want as we do not want to remove the line
				# of a new kodkodi being installed during an upgrade.
				sed -e "/contrib\/${PN}-${PV}/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
		fi
	fi
}
