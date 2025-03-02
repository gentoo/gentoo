# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Bean Script Framework"
HOMEPAGE="https://commons.apache.org/proper/commons-bsf/"
SRC_URI="mirror://apache/commons/bsf/source/bsf-src-${PV}.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/bsf/source/bsf-src-${PV}.tar.gz.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# If you add new ones, add them to ant-apache-bsf too for use dependencies
IUSE="javascript tcl"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
CDEPEND="
	dev-java/commons-logging:0
	dev-java/xalan:0
	javascript? ( >=dev-java/rhino-1.8.0:0 )
	tcl? ( dev-java/jacl:0 )
"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( CHANGES.txt NOTICE.txt README.txt RELEASE-NOTE.txt TODO.txt )

JAVA_GENTOO_CLASSPATH="
	commons-logging
	xalan
"
JAVA_MAIN_CLASS="org.apache.bsf.Main"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	rm -r src/org/apache/bsf/engines/{java,javaclass,jython,netrexx} || die
	if use javascript; then
		JAVA_GENTOO_CLASSPATH+=" rhino"
	else
		rm -r src/org/apache/bsf/engines/javascript || die
	fi
	if use tcl; then
		JAVA_GENTOO_CLASSPATH+=" jacl"
	else
		rm -r src/org/apache/bsf/engines/jacl || die
	fi
	# java-pkg-simple.eclass wants resources in JAVA_RESOURCE_DIRS
	mkdir res || die "create res"
	pushd src > /dev/null || die "pushd"
		find -type f -name '*.properties' \
			| xargs cp --parent -t ../res || die "copy resources"
	popd > /dev/null
}

src_install() {
	java-pkg-simple_src_install
#	java-pkg_register-optional-dependency bsh,groovy-1,jruby
}

pkg_postinst() {
	elog "Support for javascript and tcl is controlled via USE flags."
	elog "Also, following languages can be supported just by installing"
	elog "respective package with USE=\"bsf\": BeanShell (dev-java/bsh),"
	elog "Groovy (dev-java/groovy) and JRuby (dev-java/jruby)"
}
