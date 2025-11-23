# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop edo multiprocessing xdg

VER_ABBRV=7f27d794befacdb279039c3bae807ea0f3faacca
VER_LOCALES=606fa26be1d87837c4e607362b28ed58a7576875
VER_STYLES=616763159e5fbedcfb574ac02648e727b8166dad

DESCRIPTION="Graphical Java application for managing BibTeX and biblatex (.bib) databases"
HOMEPAGE="https://www.jabref.org/ https://github.com/JabRef/jabref"
SRC_URI="
	https://github.com/JabRef/jabref/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~arthurzam/distfiles/app-text/${PN}/${P}-gradle-deps.tar.xz
	https://github.com/JabRef/abbrv.jabref.org/archive/${VER_ABBRV}.tar.gz -> ${P}-abbrv.tar.gz
	https://github.com/citation-style-language/locales/archive/${VER_LOCALES}.tar.gz -> ${P}-locales.tar.gz
	https://github.com/citation-style-language/styles/archive/${VER_STYLES}.tar.gz -> ${P}-styles.tar.gz
	https://github.com/JabRef/jabref/commit/a64bb070259dd93de8cb88188e4c5bf892f2af2b.patch -> ${P}-fix-11517.patch
	https://github.com/JabRef/jabref/commit/e2ab9c016e41902d867da1d7e13ce0e5da44615f.patch -> ${P}-fix-11544.patch
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-21:*"
RDEPEND=">=virtual/jre-21"
BDEPEND="
	>=dev-java/gradle-bin-8
	dev-java/java-config
"

PATCHES=(
	"${DISTDIR}/${P}-fix-11517.patch"
	"${DISTDIR}/${P}-fix-11544.patch"
)

src_unpack() {
	default
	cp -a "${WORKDIR}"/abbrv.jabref.org-${VER_ABBRV}/* "${S}"/buildres/abbrv.jabref.org/ || die
	cp -a "${WORKDIR}"/locales-${VER_LOCALES}/* "${S}"/src/main/resources/csl-locales/ || die
	cp -a "${WORKDIR}"/styles-${VER_STYLES}/* "${S}"/src/main/resources/csl-styles/ || die
}

src_compile() {
	local -x JAVA_HOME="$(java-config --jdk-home || die)"
	einfo "Using JAVA_HOME: ${JAVA_HOME}"

	local GRADLE_ARGS=(
		--offline
		--no-daemon
		--no-watch-fs
		--parallel --max-workers="$(get_makeopts_jobs)"
		--gradle-user-home="${WORKDIR}/gradle-deps"
		-PprojVersion="${PV}"
		-PprojVersionInfo="${PV}--Gentoo"
	)
	edo gradle "${GRADLE_ARGS[@]}" assemble
}

src_install() {
	doicon -s scalable src/main/resources/icons/jabref.svg
	domenu "${FILESDIR}"/jabref.desktop
	newbin "${FILESDIR}"/jabref.sh JabRef
	dosym "JabRef" "/usr/bin/jabref"

	dodir /usr/share/${PN}
	cp -r build/resources "${ED}"/usr/share/${PN} || die
	tar -xf build/distributions/JabRef-${PV}.tar -C "${ED}"/usr/share/${PN} --strip-components=1 || die
}
