# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-testutil/ant-testutil-1.9.1.ebuild,v 1.1 2013/07/05 14:28:11 tomwij Exp $

EAPI="5"

inherit ant-tasks

DESCRIPTION="Apache Ant's optional test utility classes"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux \
	~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris \
	~x64-solaris ~x86-solaris"

CDEPEND="dev-java/ant-core:0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	>=dev-java/junit-4.11:4
	~dev-java/ant-swing-${PV}
	~dev-java/ant-junit4-${PV}"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

# The build system builds much more than it actually packages, so there are many
# build-only deps, but since those are quite common, it wasn't worth to patch it.

src_unpack() {
	ant-tasks_src_unpack base
	java-pkg_jar-from --build-only junit-4,ant-junit4,ant-swing
	java-pkg_jar-from --build-only ant-core ant-launcher.jar
}

src_compile() {
	eant test-jar
}
