# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc"

inherit java-pkg-2

MY_PN="${PN%-*}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="https://scala.epfl.ch/"
SRC_URI="https://downloads.lightbend.com/${MY_PN}/${PV}/${MY_P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	>=virtual/jre-1.8
	!dev-lang/scala"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	ebegin 'Cleaning .bat files'
	rm -f bin/*.bat || die
	eend $?

	ebegin 'Patching SCALA_HOME variable in bin/ directory'
	local f
	for f in bin/*; do
		sed -i -e 's#\(SCALA_HOME\)=.*#\1=/usr/share/scala-bin#' "$f" || die
	done
	eend $?
}

src_compile() {
	:;
}

src_install() {
	ebegin 'Installing bin scripts'
	dobin bin/*
	eend $?

	ebegin 'Installing jar files'

	cd lib/ || die

	# Unversion those libs.
	java-pkg_newjar jline-*.jar jline.jar
	java-pkg_newjar scalap-*.jar scalap.jar

	# Install these the usual way.
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
