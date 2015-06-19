# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-trax/ant-trax-1.8.2.ebuild,v 1.4 2012/05/25 11:22:46 ago Exp $

EAPI="4"

ANT_TASK_DEPNAME=""

inherit ant-tasks

DESCRIPTION="Apache Ant .jar with optional tasks depending on XML transformer (Deprecated!)"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

# it seems that xslt task will try to use Xalan2TraceSupport from ant-apache-xalan2
# when xalan happens to be on ant's classpath, so it's safer to have ant-apache-xalan2 there
# we need PDEPEND and register-optional-dependency to break circular dependency
PDEPEND="~dev-java/ant-apache-xalan2-${PV}"

src_compile() {
	# the classes were moved to ant-core in 1.8.1, this is just for compatibility
	mkdir -p build/lib/empty && cd build/lib/empty || die
	jar -cf ../${PN}.jar .
}

src_install() {
	ant-tasks_src_install
	java-pkg_register-optional-dependency ant-apache-xalan2
}

src_postinst() {
	elog "Upstream has removed ant-trax.jar as of 1.8.1 and moved the classes to ant.jar"
	elog "This package thus installs an empty jar for compatibility"
	elog "and will be removed once reverse dependencies are transitioned."
}
