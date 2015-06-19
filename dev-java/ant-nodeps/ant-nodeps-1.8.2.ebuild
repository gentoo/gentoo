# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-nodeps/ant-nodeps-1.8.2.ebuild,v 1.8 2012/05/27 21:26:45 sera Exp $

EAPI="4"

ANT_TASK_DEPNAME=""
ANT_TASK_DISABLE_VM_DEPS="true"

inherit ant-tasks

# to disable vm switching
JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"
# disable QA notice
JAVA_PKG_BSFIX="no"

DESCRIPTION="Formerly Ant's optional tasks w/o external deps, now compat empty jar"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.4" #jar
RDEPEND=""

src_compile() {
	# the classes were moved to ant-core in 1.8.2, this is just for compatibility
	mkdir -p build/lib/empty && cd build/lib/empty || die
	jar -cf ../${PN}.jar . || die
}

src_postinst() {
	elog "Upstream has removed ant-nodeps.jar as of 1.8.2 and moved the classes to ant.jar"
	elog "This package thus installs an empty jar for compatibility"
	elog "and will be removed once reverse dependencies are transitioned."
}
