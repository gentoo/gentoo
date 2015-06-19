# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/cldc-api/cldc-api-1.1-r1.ebuild,v 1.5 2015/05/17 20:20:06 pacho Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java ME Connected Limited Device Configuration API"
HOMEPAGE="http://java.sun.com/javame/reference/apis.jsp"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

# mkdir cldc-api-1.1 && cd cldc-api-1.1
# you need a login on dev.java.net - use --username username if different from your local login
# svn export https://phoneme.dev.java.net/svn/phoneme/components/cldc/trunk/src/javaapi/cldc1.1
# svn export https://phoneme.dev.java.net/svn/phoneme/components/cldc/trunk/src/javaapi/share
# cd ..
# tar -cjf cldc-api-1.1.tar.bz2 cldc-api-1.1
# move tarball to distdir, scp to d.g.o...

LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 x86"
SLOT="1.1"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"
