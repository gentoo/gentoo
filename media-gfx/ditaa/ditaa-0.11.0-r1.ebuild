# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="A utility that converts ascii-art diagrams to bitmap diagrams"
HOMEPAGE="https://github.com/stathissideris/ditaa"
SRC_URI="https://github.com/stathissideris/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"
IUSE=""

DEPEND="dev-java/leiningen-bin
	>=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jdk-1.8:*"

PATCHES=("${FILESDIR}"/ditaa-0.11.0-batik-1.14.patch)

EMAVEN_VENDOR=(
	"https://repo.maven.apache.org/maven2 commons-cli/commons-cli/1.4/commons-cli-1.4.jar"
	"https://repo.maven.apache.org/maven2 commons-cli/commons-cli/1.4/commons-cli-1.4.pom"
	"https://repo.maven.apache.org/maven2 commons-io/commons-io/1.3.1/commons-io-1.3.1.jar"
	"https://repo.maven.apache.org/maven2 commons-io/commons-io/1.3.1/commons-io-1.3.1.pom"
	"https://repo.maven.apache.org/maven2 commons-logging/commons-logging/1.0.4/commons-logging-1.0.4.jar"
	"https://repo.maven.apache.org/maven2 commons-logging/commons-logging/1.0.4/commons-logging-1.0.4.pom"
	"https://repo.maven.apache.org/maven2 net/htmlparser/jericho/jericho-html/3.4/jericho-html-3.4.jar"
	"https://repo.maven.apache.org/maven2 net/htmlparser/jericho/jericho-html/3.4/jericho-html-3.4.pom"
	"https://repo.maven.apache.org/maven2 org/apache/apache/3/apache-3.pom"
	"https://repo.maven.apache.org/maven2 org/apache/apache/4/apache-4.pom"
	"https://repo.maven.apache.org/maven2 org/apache/apache/7/apache-7.pom"
	"https://repo.maven.apache.org/maven2 org/apache/apache/18/apache-18.pom"
	"https://repo.maven.apache.org/maven2 org/apache/commons/commons-parent/42/commons-parent-42.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-anim/1.14/batik-anim-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-anim/1.14/batik-anim-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-awt-util/1.14/batik-awt-util-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-awt-util/1.14/batik-awt-util-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-bridge/1.14/batik-bridge-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-bridge/1.14/batik-bridge-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-codec/1.14/batik-codec-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-codec/1.14/batik-codec-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-constants/1.14/batik-constants-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-constants/1.14/batik-constants-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-css/1.14/batik-css-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-css/1.14/batik-css-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-dom/1.14/batik-dom-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-dom/1.14/batik-dom-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-ext/1.14/batik-ext-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-ext/1.14/batik-ext-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-gvt/1.14/batik-gvt-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-gvt/1.14/batik-gvt-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-i18n/1.14/batik-i18n-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-i18n/1.14/batik-i18n-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-parser/1.14/batik-parser-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-parser/1.14/batik-parser-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-script/1.14/batik-script-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-script/1.14/batik-script-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-shared-resources/1.14/batik-shared-resources-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-shared-resources/1.14/batik-shared-resources-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-svggen/1.14/batik-svggen-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-svggen/1.14/batik-svggen-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-svg-dom/1.14/batik-svg-dom-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-svg-dom/1.14/batik-svg-dom-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-transcoder/1.14/batik-transcoder-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-transcoder/1.14/batik-transcoder-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-util/1.14/batik-util-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-util/1.14/batik-util-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-xml/1.14/batik-xml-1.14.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik-xml/1.14/batik-xml-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/batik/1.14/batik-1.14.pom"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/xmlgraphics-commons/2.6/xmlgraphics-commons-2.6.jar"
	"https://repo.maven.apache.org/maven2 org/apache/xmlgraphics/xmlgraphics-commons/2.6/xmlgraphics-commons-2.6.pom"
	"https://repo.maven.apache.org/maven2 org/clojure/clojure/1.9.0/clojure-1.9.0.jar"
	"https://repo.maven.apache.org/maven2 org/clojure/clojure/1.9.0/clojure-1.9.0.pom"
	"https://repo.maven.apache.org/maven2 org/clojure/core.specs.alpha/0.1.24/core.specs.alpha-0.1.24.jar"
	"https://repo.maven.apache.org/maven2 org/clojure/core.specs.alpha/0.1.24/core.specs.alpha-0.1.24.pom"
	"https://repo.maven.apache.org/maven2 org/clojure/pom.contrib/0.2.2/pom.contrib-0.2.2.pom"
	"https://repo.maven.apache.org/maven2 org/clojure/spec.alpha/0.1.143/spec.alpha-0.1.143.jar"
	"https://repo.maven.apache.org/maven2 org/clojure/spec.alpha/0.1.143/spec.alpha-0.1.143.pom"
	"https://repo.maven.apache.org/maven2 xalan/serializer/2.7.2/serializer-2.7.2.jar"
	"https://repo.maven.apache.org/maven2 xalan/serializer/2.7.2/serializer-2.7.2.pom"
	"https://repo.maven.apache.org/maven2 xalan/xalan/2.7.2/xalan-2.7.2.jar"
	"https://repo.maven.apache.org/maven2 xalan/xalan/2.7.2/xalan-2.7.2.pom"
	"https://repo.maven.apache.org/maven2 xml-apis/xml-apis-ext/1.3.04/xml-apis-ext-1.3.04.jar"
	"https://repo.maven.apache.org/maven2 xml-apis/xml-apis-ext/1.3.04/xml-apis-ext-1.3.04.pom"
	"https://repo.maven.apache.org/maven2 xml-apis/xml-apis/1.3.04/xml-apis-1.3.04.pom"
	"https://repo.maven.apache.org/maven2 xml-apis/xml-apis/1.4.01/xml-apis-1.4.01.jar"
	"https://repo.maven.apache.org/maven2 xml-apis/xml-apis/1.4.01/xml-apis-1.4.01.pom"
)

__set_vendor_uri() {
	local lib
	for lib in "${EMAVEN_VENDOR[@]}"; do
		SRC_URI+=" ${lib%% *}/${lib##* }"
	done
}

__set_vendor_uri
unset -f __set_vendor_uri

src_unpack() {
	unpack "${P}.tar.gz"
	local d f maven_basedir="${T}/m2"
	mkdir -p "${maven_basedir}" || die
	for f in "${EMAVEN_VENDOR[@]}"; do
		f=${f##* }
		d=${f%/*}
		f=${f##*/}
		mkdir -p "${maven_basedir}"/"${d}" || die
		cp "${DISTDIR}/${f}" "${maven_basedir}/${d}/" || die
	done
}

src_prepare () {
	default
	java-pkg-2_src_prepare
}

src_compile() {
	export HOME=${T}
	mkdir ~/.lein || die
	printf -- '{
	:user  {
		:local-repo "%s"
		:repositories  {
			"local" {
				:url "file://%s"
				:releases {:checksum :ignore}
			}
		}
	}
}\n' "${T}/m2" "${T}/m2" > ~/.lein/profiles.clj || die
	lein -o uberjar || die
}

src_install() {
	java-pkg_newjar target/${P}-standalone.jar ${PN}.jar
	java-pkg_dolauncher ${PN}
}
