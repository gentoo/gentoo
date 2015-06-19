# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-jmf/ant-jmf-1.9.1.ebuild,v 1.3 2015/04/02 18:00:48 mr_bones_ Exp $

EAPI="5"

# Seems we don't need to depend on jmf-bin, the classes ant imports are in J2SE
# API since version 1.3.
ANT_TASK_DEPNAME=""

inherit ant-tasks

DESCRIPTION="Apache Ant's optional tasks for the Java Media Framework (JMF)"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux \
	~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
