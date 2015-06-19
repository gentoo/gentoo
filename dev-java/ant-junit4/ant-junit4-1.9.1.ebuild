# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-junit4/ant-junit4-1.9.1.ebuild,v 1.1 2013/07/05 14:20:20 tomwij Exp $

EAPI="5"

ANT_TASK_JDKVER=1.5
ANT_TASK_JREVER=1.5
ANT_TASK_DEPNAME="junit-4"

inherit ant-tasks

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

DEPEND="dev-java/junit:4
	~dev-java/ant-junit-${PV}"

RDEPEND="${DEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="junit-4,ant-junit"

src_compile() {
	eant jar-junit4
}

src_install() {
	# No registration as ant-task, would be loaded together with ant-junit.
	java-pkg_dojar build/lib/ant-junit4.jar

	# As we dont't want to depend on and-junit in package.env, because it depends
	# on junit:0. Instead, we "steal" its jar and record it to our package.env as
	# if it belongs to this package's classpath.
	java-pkg_getjar --build-only ant-junit ant-junit.jar
	java-pkg_regjar $(java-pkg_getjar --build-only ant-junit ant-junit.jar)
}
