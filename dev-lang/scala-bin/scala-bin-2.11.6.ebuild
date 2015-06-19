# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/scala-bin/scala-bin-2.11.6.ebuild,v 1.3 2015/06/14 18:46:48 monsieurp Exp $

EAPI=5

inherit java-pkg-2

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="http://scala.epfl.ch/"
SRC_URI="http://downloads.typesafe.com/scala/${PV}/scala-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc"

DEPEND=""
RDEPEND=">=virtual/jre-1.6
	!dev-lang/scala"

JAVA_PKG_IUSE="doc"

S=${WORKDIR}/scala-${PV}

java_prepare() {
	ebegin 'Cleaning .bat files'
	rm -f bin/*.bat || die
	eend $?

	ebegin 'Patching SCALA_HOME variable in bin/ scripts'
	for f in bin/*; do
		sed -i -e 's#\(SCALA_HOME\)=.*#\1=/usr/share/scala-bin#' $f || die
	done
	eend $?
}

src_install() {
	ebegin 'Installing bin scripts'
	dobin bin/*
	eend $?

	ebegin 'Installing jar files'
	cd lib/ || die

	# Unversion those libs
	java-pkg_newjar scala-continuations-library_*.jar scala-continuations-library.jar
	java-pkg_newjar akka-actor_*.jar akka-actor.jar
	java-pkg_newjar config-*.jar config.jar
	java-pkg_newjar scala-actors-2.11.0.jar scala-actors.jar
	java-pkg_newjar scala-actors-migration_*.jar scala-actors-migration.jar
	java-pkg_newjar scala-swing_*.jar scala-swing.jar
	java-pkg_newjar scala-parser-combinators_*.jar scala-parser-combinators.jar
	java-pkg_newjar scala-xml_*.jar scala-xml.jar
	java-pkg_newjar jline-*.jar jline.jar
	java-pkg_newjar scala-continuations-plugin_*.jar scala-continuations-plugin.jar
	java-pkg_newjar scalap-*.jar scalap.jar

	# Install these the usual way
	java-pkg_dojar scala-compiler.jar
	java-pkg_dojar scala-library.jar
	java-pkg_dojar scala-reflect.jar

	eend $?

	cd ../ || die

	ebegin 'Installing man pages'
	doman man/man1/*.1
	eend $?

	if use doc; then
		ebegin 'Installing documentation'
		java-pkg_dohtml -r doc/tools
		eend $?
	fi
}
