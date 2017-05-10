# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit java-pkg-2

MY_PN="${PN%-bin}"
MY_PNV="${MY_PN}-${PV}"

DESCRIPTION="Automate Clojure projects without setting your hair on fire"
HOMEPAGE="https://leiningen.org/"
SRC_URI="
	https://github.com/technomancy/${MY_PN}/releases/download/${PV}/${MY_PNV}-standalone.zip -> ${MY_PNV}-standalone.jar
	https://raw.githubusercontent.com/technomancy/${MY_PN}/${PV}/bin/lein-pkg -> ${MY_PNV}.sh
"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

RESTRICT="test"

src_unpack() {
	mkdir -p "${S}" || die "Can't mkdir ${S}"
	cd "${S}"	|| die "Can't enter ${S}"
	for file in ${A}; do
		einfo "Copying ${file}"
		cp "${DISTDIR}/${file}" "${S}/" || die "Can't copy ${file}"
	done
}

src_prepare() {
	einfo "Copying leinrc"
	cp "${FILESDIR}/leinrc" "${S}/" || die "Can't copy leinrc"
	einfo "Patching leinrc"
	sed -i "s^@@PN@@^${PN}^" "${S}/leinrc" || die "Can't patch leinrc"

	einfo "Renaming lein-pkg"
	# Rename generically to help user patching
	mv "${S}/${MY_PNV}.sh" "${S}/lein" || die "Can't rename to lein"

	einfo "Patching lein"
	java-pkg_init_paths_
	sed -i "s|^LEIN_JAR=.*$|LEIN_JAR=${EPREFIX}/${JAVA_PKG_JARDEST#/}/${PN}.jar|" "${S}/lein" \
		|| die "Can't patch LEIN_JAR in lein"

	default
}

src_compile() { :; }

src_install() {
	dobin "${S}/lein"
	java-pkg_newjar "${MY_PNV}-standalone.jar"
	insinto /etc
	doins "${S}/leinrc"
	fperms 0644 "/etc/leinrc"
}
