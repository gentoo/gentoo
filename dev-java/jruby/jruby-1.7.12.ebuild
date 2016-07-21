# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java-based Ruby interpreter implementation"
HOMEPAGE="http://jruby.codehaus.org/"
SRC_URI="http://jruby.org.s3.amazonaws.com/downloads/${PV}/${PN}-src-${PV}.tar.gz
	https://dev.gentoo.org/~tomwij/files/dist/${P}-mvn-ant-ant.patch"

LICENSE="|| ( EPL-1.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"

RUBY_VERSION=1.9
RUBY_REVISION=0

CDEPEND="
	dev-java/ant-core:0
	dev-java/asm:4
	dev-java/bsf:2.3
	>=dev-java/bytelist-1.0.8:0
	dev-java/headius-options:0
	dev-java/invokebinder:0
	dev-java/jcodings:1
	dev-java/jffi:1.2
	dev-java/jnr-constants:0
	dev-java/jnr-enxio:0
	dev-java/jnr-ffi:0.7
	>=dev-java/jnr-netdb-1.0:0
	dev-java/jnr-posix:2.4
	dev-java/jnr-unixsocket:0
	dev-java/joda-time:0
	dev-java/joni:2.1
	dev-java/nailgun:0
	dev-java/osgi-core-api:0
	dev-lang/ruby:${RUBY_VERSION}
	>=dev-java/snakeyaml-1.9:0
	dev-java/jzlib:1.1
"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8
"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8
	test? (
		dev-java/ant-junit4:0
		dev-java/ant-trax:0
		dev-java/commons-logging:0
		dev-java/junit:4
		dev-java/xalan:0
		java-virtuals/jdk-with-com-sun:0
	)
"

RUBY_HOME=/usr/share/${PN}/lib/ruby
SITE_RUBY=${RUBY_HOME}/site_ruby
GEMS=${RUBY_HOME}/gems

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"

EANT_GENTOO_CLASSPATH="ant-core asm-4 bsf-2.3 bytelist headius-options \
invokebinder jcodings-1 jffi-1.2 jnr-constants jnr-enxio jnr-ffi-0.7 jnr-netdb \
jnr-posix-2.4 jnr-unixsocket joda-time joni-2.1 nailgun osgi-core-api snakeyaml \
jzlib-1.1"

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH} ant-junit4 ant-trax \
commons-logging junit-4 xalan jdk-with-com-sun"

EANT_BUILD_TARGET="package"

pkg_setup() {
	export RUBYOPT=""
	java-pkg-2_pkg_setup

	local fail
	for directory in "${GEMS}" "${SITE_RUBY}"; do
		if [[ -L ${directory} ]]; then
			eerror "${directory} is a symlink. Please do the following to resolve the situation:"
			echo 'emerge -an app-portage/gentoolkit'
			echo 'equery -qC b '"${directory}"' | sort | uniq | sed s/^/=/ > /tmp/jruby.fix'
			echo 'emerge -1C $(< /tmp/jruby.fix)'
			echo "rm ${directory}"
			echo 'emerge -1 $(< /tmp/jruby.fix)'

			eerror "For more information, please see https://bugs.gentoo.org/show_bug.cgi?id=302187"
			fail="true"
		fi
	done

	if [[ -n ${fail} ]]; then
		die "Please address the above errors, then run emerge --resume"
	fi
}

java_prepare() {
	einfo "Cleaning up bash launcher ..."
	epatch "${FILESDIR}"/${P}-bash-launcher.patch

	# When you capture a new patch, and it misses org.jruby.runtime.Constants;
	# add maven.build.resourceDir.1 as a pathelement to the javac task of the
	# compilation target. Also add jruby-core-GENTOO_JRUY_VER in ext classpaths.
	# Also reorder the root maven-build.xml such that core compiles before ext.
	einfo "Patching build.xml ..."
	epatch "${DISTDIR}"/${P}-mvn-ant-ant.patch
	find . -name '*build.xml' -exec \
		sed -i "s/jruby-core-GENTOO_JRUY_VER/jruby-core-${PV}/" {} \;

	einfo "Removing classes and jars ..."
	find . -name "*.class" -or -name "*.jar" -print -delete

	einfo "Fixing up properties ..."
	JRUBY_CONSTANTS="core/src/main/resources/org/jruby/runtime/Constants.java"
	for repvar in $(grep "@.*@\".*;" ${JRUBY_CONSTANTS} | sed 's:.*@\(.*\)@.*:\1:') ; do
		VAR=$(grep "<${repvar}>" pom.xml | sed 's/.*>\(.*\)<\/.*/\1/')
		sed -i "s/@${repvar}@/${VAR}/" \
			${JRUBY_CONSTANTS} || die
	done
	sed -i "s/String VERSION = \".*\"/String VERSION = \"${PV}\"/" \
		${JRUBY_CONSTANTS} || die

	einfo "Setting Ruby version to use ..."
	sed -i -e "s/String jruby_revision = \"\"/String jruby_revision = \"${RUBY_REVISION}\"/" \
		-e "s/String jruby_default_ruby_version = \"\"/String jruby_default_ruby_version = \"${RUBY_VERSION}\"/" \
		${JRUBY_CONSTANTS} || die
}

# Java based tests return propertly, I guess that is because there are none;
# I've found an executable that can you can run, but it bails out about libyaml.
#
#  $ bin/testrb test
# /usr/share/jruby/lib/ruby/1.9/yaml/store.rb:1:in `require':
# It seems your ruby installation is missing psych (for YAML output).
# To eliminate this warning, please install libyaml and reinstall your ruby.
# JRuby 1.9 mode only supports the `psych` YAML engine; ignoring `syck`
# NoMethodError: undefined method `to_yaml' for {}:Hash
#        Store at /usr/share/jruby/lib/ruby/1.9/yaml/store.rb:78
#        ...
RESTRICT="${RESTRICT} test"

src_test() {
	export RUBYOPT=""

	mv maven-build.xml build.xml || die

	java-pkg-2_src_test

	bin/testrb test || die ""
}

src_install() {
	java-pkg_newjar core/target/${PN}-core-${PV}.jar
	dodoc README.md docs/{*.txt,README.*} || die

	use doc && java-pkg_dojavadoc core/target/site/apidocs
	use source && java-pkg_dosrc core/src/main/java/org

	newbin bin/jruby.bash jruby
	dobin bin/j{irb{,_swing},rubyc}

	insinto "${RUBY_HOME}"
	doins -r "${S}"/lib/ruby/{1.8,1.9,2.0,shared}

	# Remove all the references to RubyGems as we're just going to
	# install it through dev-ruby/rubygems.
	find "${ED}${RUBY_HOME}" -type f \
		'(' '(' -path '*rubygems*' -not -name 'jruby.rb' ')' -or -name 'ubygems.rb' -or -name 'datadir.rb' ')' \
		-delete || die
}

pkg_postinst() {
	ewarn ""
	ewarn "Make sure RUBYOPT is unset in the environment when using JRuby:"
	ewarn ""
	ewarn "    export RUBYOPT=\"\""
	ewarn ""
}
