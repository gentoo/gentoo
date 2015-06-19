# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-nodeps/ant-nodeps-1.9.2.ebuild,v 1.5 2013/10/20 16:32:13 ago Exp $

EAPI="5"

ANT_TASK_DEPNAME=""
ANT_TASK_DISABLE_VM_DEPS="true"

inherit ant-tasks

DESCRIPTION="Formerly Ant's optional tasks w/o external deps, now compat empty jar"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Dependency needed for jar.
DEPEND=">=virtual/jdk-1.4"

src_compile() {
	# The classes were moved to ant-core in 1.8.2, this is just for compatibility.
	mkdir -p build/lib/empty && cd build/lib/empty || die
	jar -cf ../${PN}.jar . || die
}

pkg_postinst() {
	elog "Upstream has removed ant-nodeps.jar as of 1.8.2 and moved the classes to ant.jar"
	elog "This package thus installs an empty jar for compatibility"
	elog "and will be removed once reverse dependencies are transitioned."
}
