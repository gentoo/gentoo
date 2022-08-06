# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Automate Clojure projects without setting your hair on fire"
HOMEPAGE="https://leiningen.org/"
SRC_URI="
	https://github.com/technomancy/leiningen/releases/download/${PV}/leiningen-${PV}-standalone.jar
	https://raw.githubusercontent.com/technomancy/leiningen/${PV}/bin/lein-pkg -> leiningen-${PV}.sh
"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~x64-macos"
IUSE="+binary"

RDEPEND=">=virtual/jre-1.8"

JAVA_BINJAR_FILENAME="leiningen-${PV}-standalone.jar"

src_prepare() {
	default
	einfo "Creating leinrc"
	echo "source /usr/share/leiningen-bin/package.env" > \
		"${S}/leinrc" || die "Cannot create leinrc"

	einfo "Renaming lein-pkg"
	cp "${DISTDIR}/leiningen-${PV}.sh" "${S}/lein" || die "Can't rename to lein"

	einfo "Patching lein"
	java-pkg_init_paths_
	sed -i "s|^LEIN_JAR=.*$|LEIN_JAR=${EPREFIX}/${JAVA_PKG_JARDEST#/}/${PN}.jar|" \
		"${S}/lein" || die "Can't patch LEIN_JAR in lein"
}

src_install() {
	java-pkg-simple_src_install
	dobin "${S}/lein"
	insinto /etc
	doins "${S}/leinrc"
	fperms 0644 "/etc/leinrc"
}
