# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/weakling/weakling-0.0.4.ebuild,v 1.3 2014/03/04 20:19:19 ago Exp $

EAPI=5

# This package is specifically for JRuby.
USE_RUBY="jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="HISTORY.txt README.txt"
RUBY_FAKEGEM_SUFFIX="java"
RUBY_FAKEGEM_TASK_TEST=""

inherit java-pkg-2 java-pkg-simple ruby-fakegem

DESCRIPTION="weakling: a collection of weakref utilities for Ruby"
HOMEPAGE="http://github.com/headius/weakling"
LICENSE="Apache-2.0"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

CDEPEND="dev-java/bytelist
	dev-java/jruby"

DEPEND+=" ${CDEPEND}
	>=virtual/jdk-1.5"

RDEPEND+=" ${CDEPEND}
	>=virtual/jre-1.5"

JAVA_GENTOO_CLASSPATH="bytelist jruby"

pkg_setup() {
	java-pkg-2_pkg_setup
	ruby-ng_pkg_setup
}

each_ruby_compile() {
	java-pkg-simple_src_compile
	cp "${PN}.jar" "lib/refqueue.jar" || die
}
