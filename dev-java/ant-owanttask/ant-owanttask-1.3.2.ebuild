# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-owanttask/ant-owanttask-1.3.2.ebuild,v 1.6 2015/07/11 09:21:05 chewi Exp $

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="ObjectWeb's Ant tasks"
HOMEPAGE="http://monolog.objectweb.org"
SRC_URI="http://download.forge.objectweb.org/monolog/ow_util_ant_tasks_${PV}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

COMMON_DEP="dev-java/xalan"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	>=dev-java/ant-core-1.7.0
	${COMMON_DEP}"

S=${WORKDIR}

src_prepare() {
	rm -f output/lib/*.jar
}

src_install() {
	java-pkg_dojar output/lib/ow_util_ant_tasks.jar
}

pkg_postinst() {
	ewarn "The MultipleCopy task is not compatible with ant-1.7.0 and newer"
	ewarn "Attempt to use it will break building."
}
