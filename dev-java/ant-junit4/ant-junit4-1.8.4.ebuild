# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-junit4/ant-junit4-1.8.4.ebuild,v 1.5 2012/12/05 17:32:44 ago Exp $

EAPI="4"

ANT_TASK_JDKVER=1.5
ANT_TASK_JREVER=1.5
ANT_TASK_DEPNAME="junit-4"

inherit ant-tasks

KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-java/junit:4
	~dev-java/ant-junit-${PV}"
RDEPEND="${DEPEND}"

src_compile() {
	eant jar-junit4
}

src_install() {
	# no registration as ant-task, would be loaded together with ant-junit
	java-pkg_dojar build/lib/ant-junit4.jar

	# As we dont't want to depend on and-junit in package.env, because it depends
	# on junit:0. Instead, we "steal" its jar and record it to our package.env as
	# if it belongs to this package's classpath
	java-pkg_getjar --build-only ant-junit ant-junit.jar
	java-pkg_regjar $(java-pkg_getjar --build-only ant-junit ant-junit.jar)
}
