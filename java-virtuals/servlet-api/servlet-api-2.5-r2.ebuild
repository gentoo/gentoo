# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-virtuals-2

DESCRIPTION="Virtual for servlet api"
HOMEPAGE="http://java.sun.com/products/servlet/"
SRC_URI=""

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"

RDEPEND="dev-java/tomcat-servlet-api:${SLOT}"

JAVA_VIRTUAL_PROVIDES="tomcat-servlet-api-${SLOT}"
