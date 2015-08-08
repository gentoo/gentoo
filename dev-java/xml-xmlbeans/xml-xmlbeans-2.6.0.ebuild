# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_P="xmlbeans-${PV}"

DESCRIPTION="An XML-Java binding tool"
HOMEPAGE="http://xmlbeans.apache.org/"
SRC_URI="http://archive.apache.org/dist/xmlbeans/source/${MY_P}-src.zip"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"

COMMON_DEP="dev-java/annogen:0
	dev-java/ant-core:0
	dev-java/jsr173:0
	dev-java/piccolo:0
	dev-java/saxon:9
	dev-java/xml-commons-resolver:0"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	# Preserve the old xbean jar, which is required for bootstrapping schemas.
	mv external/lib/oldxbean.jar "${T}"/ || die

	# Remove bundled binary files.
	find . -name '*.jar' -exec rm -v {} + || die

	pushd external/lib > /dev/null || die
		find . -iname '*.zip' -exec rm -v {} + || die

		# Symlink the dependencies.
		java-pkg_jar-from jsr173{,.jar,_1.0_api_bundle.jar}
		java-pkg_jar-from jsr173{,.jar,_1.0_api.jar}

		mkdir xml-commons-resolver-1.1 || die
		java-pkg_jar-from xml-commons-resolver{,.jar} xcresolver.zip
		java-pkg_jar-from xml-commons-resolver{,.jar,-1.1/resolver.jar}

		# Put back the preserved old xbean jar.
		mv "${T}"/oldxbean.jar . || die
	popd > /dev/null || die

	# Remove broken jamsupport.
	epatch "${FILESDIR}"/${P}-remove-jamsupport.patch

	# Patch package imports.
	epatch "${FILESDIR}"/${P}-piccolo.patch
	epatch "${FILESDIR}"/${P}-jam.patch

	# Create empty directories to let the build pass.
	mkdir -p build/classes/{jam,piccolo}
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="annogen,ant-core,piccolo,saxon-9"

EANT_BUILD_TARGET="deploy"
EANT_DOC_TARGET="docs"

EANT_EXTRA_ARGS="-Dpiccolo.classes.notRequired=true"
EANT_EXTRA_ARGS+=" -Djam.classes.notRequired=true"
EANT_EXTRA_ARGS+=" -Dsaxon9.jar.exists=true"

src_install() {
	java-pkg_dojar build/lib/xbean*.jar

	dodoc NOTICE.txt README.txt
	if use doc; then
		java-pkg_dojavadoc build/docs/reference
		java-pkg_dohtml -r docs
	fi

	use source && java-pkg_dosrc src/*
}

pkg_postinst()
{
	ewarn "This package uses an old binary xbean to bootstrap its schemas."
	ewarn "If you do not trust the binary part of this build, please unmerge."
}
